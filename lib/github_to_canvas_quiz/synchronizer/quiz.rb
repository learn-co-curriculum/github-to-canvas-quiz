# frozen_string_literal: true

module GithubToCanvasQuiz
  module Synchronizer
    class Quiz
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def sync(path)
        raise GithubToCanvasQuiz::FileNotFoundError unless File.exist? path

        quiz = load_quiz(path)
        canvas_quiz = save_to_canvas(quiz)
        unless quiz.id
          quiz.id = canvas_quiz['id']
          update_readme(path, quiz)
        end
        quiz
      end

      private

      def load_quiz(path)
        md = File.read(path)
        GithubToCanvasQuiz::Converter::Quiz.from_markdown(md)
      end

      def save_to_canvas(quiz)
        if quiz.id
          client.update_quiz(quiz.course_id, quiz.id, { 'quiz' => quiz.to_h })
        else
          client.create_quiz(quiz.course_id, { 'quiz' => quiz.to_h })
        end
      end

      # TODO: only update frontmatter?
      def update_readme(path, quiz)
        File.write(path, quiz.to_markdown)
      end
    end
  end
end
