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
      attr_reader :client, :path, :git

      def initialize(client, path)
        path = File.expand_path(path)
        raise DirectoryNotFoundError unless Pathname(path).directory?

        @client = client
        @path = path

        # TODO: this assumes the given path is a git repo; raise error if not?
        @git = Git.open(path)
      end

      def sync
        backup_canvas_to_json!
        sync_quiz!
        sync_questions!
        backup_canvas_to_json!
      end

      private

      # create or update quiz on Canvas
      def sync_quiz!
        payload = { 'quiz' => quiz.to_h }
        if quiz.id
          # update existing quiz
          client.update_quiz(quiz.course_id, quiz.id, payload)
        else
          # create new quiz
          canvas_quiz = client.create_quiz(quiz.course_id, payload)
          quiz.id = canvas_quiz['id']
          update_frontmatter(quiz_path, quiz)
        end
      end

      def sync_questions!
        questions_with_path.each do |question_with_path|
          question, path = question_with_path
          create_or_update_question(question, path)
        end
        remove_deleted_questions
      end

      def backup_canvas_to_json!
        quiz_data = client.get_single_quiz(quiz.course_id, quiz.id)
        questions_data = client.list_questions(quiz.course_id, quiz.id)

        json_data = JSON.pretty_generate({ quiz: quiz_data, questions: questions_data })
        File.write(json_path, json_data)
        commit_file(json_path, 'Created Canvas snapshot')
      end

      def json_path
        File.join(path, '.canvas-snapshot.json')
      end

      # Get quiz data from the Markdown file and return a Model::Quiz
      # memoized to prevent unnecessary file parsing
      def quiz
        raise GithubToCanvasQuiz::FileNotFoundError unless Pathname(quiz_path).exist?

        @quiz ||= Parser::Markdown::Quiz.new(quiz_path).parse
      end

      def quiz_path
        File.join(path, 'README.md')
      end

      def questions_with_path
        @questions_with_path ||= Dir["#{path}/questions/*.md"].map do |question_path|
          question = Parser::Markdown::Question.new(File.read(question_path)).parse
          question.quiz_id = quiz.id
          question.course_id = quiz.course_id
          [question, question_path] # need that question path... gotta be a better way!
        end
      end

      def create_or_update_question(question, path)
        payload = { 'question' => question.to_h }
        if question.id
          # update existing question
          client.update_question(question.course_id, question.quiz_id, question.id, payload)
        else
          # create new question
          canvas_question = client.create_question(question.course_id, question.quiz_id, payload)
          question.id = canvas_question['id']
          update_frontmatter(path, question)
        end
      end

      def remove_deleted_questions
        ids = questions_with_path.map { |question_with_path| question_with_path.first.id }
        client.list_questions(quiz.course_id, quiz.id).each do |canvas_question|
          id = canvas_question['id']
          unless ids.include?(id)
            # delete questions that are no longer present in the repo
            client.delete_question(quiz.course_id, quiz.id, id)
          end
        end
      end

      def update_frontmatter(filepath, markdownable)
        parsed = FrontMatterParser::Parser.parse_file(filepath)
        new_markdown = MarkdownBuilder.build do |md|
          md.frontmatter(markdownable.frontmatter_hash)
          md.md(parsed.content)
        end
        File.write(filepath, new_markdown)
        commit_file(filepath, 'Updated frontmatter')
      end

      def commit_file(filepath, message)
        relative_path = Pathname(filepath).relative_path_from(path).to_s
        return unless git.status.untracked?(relative_path) || git.status.changed?(relative_path)

        git.add(relative_path)
        git.commit("AUTO: #{message}")
      end
    end
  end
end
