# frozen_string_literal: true

module GithubToCanvasQuiz
  # Markdown => CanvasAPI
  module Synchronizer
    # Synchronize a quiz on Canvas based on the contents of a given directory
    class Quiz
      attr_reader :client, :path

      def initialize(client, path)
        raise DirectoryNotFoundError unless File.directory? path

        @client = client
        @path = path
      end

      def sync
        sync_quiz!
        sync_questions!
      end

      private

      # Get quiz data from the Markdown file and return a Model::Quiz
      # memoized to prevent unnecessary file parsing
      def quiz
        return @quiz if defined? @quiz

        @quiz = begin
          raise GithubToCanvasQuiz::FileNotFoundError unless File.exist? quiz_path

          Parser::Markdown::Quiz.new(File.read(quiz_path)).parse
        end
      end

      def quiz_path
        "#{path}/README.md"
      end

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
          sync_quiz_to_markdown!
        end
      end

      # TODO: only update frontmatter?
      def sync_quiz_to_markdown!
        File.write(quiz_path, quiz.to_markdown)
      end

      def questions_with_path
        @questions_with_path ||= Dir["#{path}/questions/*.md"].map do |question_path|
          question = Parser::Markdown::Question.new(File.read(question_path)).parse
          question.quiz_id = quiz.id
          question.course_id = quiz.course_id
          [question, question_path] # need that question path... gotta be a better way!
        end
      end

      def sync_questions!
        questions_with_path.each do |question_with_path|
          question, path = question_with_path
          create_or_update_question(question, path)
        end
        remove_deleted_questions
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
          sync_question_to_markdown!(path, question)
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

      # TODO: only update frontmatter?
      def sync_question_to_markdown!(path, question)
        File.write(path, question.to_markdown)
      end
    end
  end
end
