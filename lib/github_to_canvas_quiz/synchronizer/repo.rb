# frozen_string_literal: true

module GithubToCanvasQuiz
  module Synchronizer
    class Repo
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def sync(path)
        raise GithubToCanvasQuiz::DirectoryNotFoundError unless File.directory? path

        # sync quiz
        quiz = Quiz.new(client).sync("#{path}/README.md")
        # sync questions
        questions = Dir["#{path}/questions/*.md"].map do |question_path|
          Question.new(client).sync(question_path)
        end
        # delete questions that are no longer in the repo
        delete_questions(quiz, questions)
      end

      private

      def delete_questions(quiz, questions)
        existing_question_ids = questions.map(&:id)
        canvas_questions = client.list_questions(quiz.course_id, quiz.id)
        canvas_questions.each do |canvas_question|
          id = canvas_question['id']
          client.delete_question(quiz.course_id, quiz.id, id) unless existing_question_ids.include?(id)
        end
      end
    end
  end
end
