# frozen_string_literal: true

module GithubToCanvasQuiz
  # Markdown => CanvasAPI
  module Synchronizer
    # Synchronize a quiz to Canvas based on the contents of a given directory
    # Given a directory with valid markdown files:
    #
    # phase-1-quiz-arrays
    # |   questions
    # |   |-- 00.md
    # |   |-- 01.md
    # |-- README.md
    #
    # Useage:
    #
    #   client = CanvasAPI::Client.new(host: host, api_key: api_key)
    #   Synchronizer::Quiz.new(client, 'phase-1-quiz-arrays')
    class Quiz
      attr_reader :client, :path, :repo, :quiz, :questions_with_path

      def initialize(client, path)
        path = File.expand_path(path)
        raise DirectoryNotFoundError unless Pathname(path).directory?

        @client = client
        @path = path
        @repo = RepositoryInterface.new(path)
        @quiz = parse_quiz
        @questions_with_path = parse_questions_with_path
      end

      def sync
        backup_canvas_to_json!
        sync_quiz!
        sync_questions!
        backup_canvas_to_json!
      end

      private

      # Get quiz data from the Markdown file and return a Model::Quiz
      def parse_quiz
        raise GithubToCanvasQuiz::FileNotFoundError unless Pathname(quiz_path).exist?

        Parser::Markdown::Quiz.new(quiz_path).parse
      end

      # Get question data from Markdown files and return a Model::Question along with its path
      def parse_questions_with_path
        Dir["#{path}/questions/*.md"].map do |question_path|
          question = Parser::Markdown::Question.new(File.read(question_path)).parse
          question.quiz_id = quiz.id
          question.course_id = quiz.course_id
          [question, question_path] # need that question path... gotta be a better way!
        end
      end

      # create or update quiz on Canvas
      def sync_quiz!
        if quiz.id
          update_quiz!
        else
          create_quiz_and_update_frontmatter!
        end
      end

      def update_quiz!
        client.update_quiz(quiz.course_id, quiz.id, { 'quiz' => quiz.to_h })
      end

      def create_quiz_and_update_frontmatter!
        canvas_quiz = client.create_quiz(quiz.course_id, { 'quiz' => quiz.to_h })
        quiz.id = canvas_quiz['id']
        update_frontmatter(quiz_path, quiz)
      end

      def quiz_path
        File.join(path, 'README.md')
      end

      # Create or update questions on Canvas
      def sync_questions!
        questions_with_path.each do |question_with_path|
          question, path = question_with_path
          if question.id
            update_question!(question)
          else
            create_question_and_update_frontmatter!(question, path)
          end
        end
        remove_deleted_questions!
      end

      def create_question_and_update_frontmatter!(question, path)
        canvas_question = client.create_question(question.course_id, question.quiz_id, { 'question' => question.to_h })
        question.id = canvas_question['id']
        update_frontmatter(path, question)
      end

      def update_question!(question)
        client.update_question(question.course_id, question.quiz_id, question.id, { 'question' => question.to_h })
      end

      def remove_deleted_questions!
        ids = questions_with_path.map { |question_with_path| question_with_path.first.id }
        client.list_questions(quiz.course_id, quiz.id).each do |canvas_question|
          id = canvas_question['id']
          unless ids.include?(id)
            # delete questions that are no longer present in the repo
            client.delete_question(quiz.course_id, quiz.id, id)
          end
        end
      end

      def backup_canvas_to_json!
        quiz_data = client.get_single_quiz(quiz.course_id, quiz.id)
        questions_data = client.list_questions(quiz.course_id, quiz.id)

        json_data = JSON.pretty_generate({ quiz: quiz_data, questions: questions_data })
        File.write(json_path, json_data)
        repo.commit_files(json_path, 'Created Canvas snapshot')
      end

      def json_path
        File.join(path, '.canvas-snapshot.json')
      end

      def update_frontmatter(filepath, markdownable)
        parsed = FrontMatterParser::Parser.parse_file(filepath)
        new_markdown = MarkdownBuilder.build do |md|
          md.frontmatter(markdownable.frontmatter_hash)
          md.md(parsed.content)
        end
        File.write(filepath, new_markdown)
        repo.commit_files(filepath, 'Updated frontmatter')
      end
    end
  end
end
