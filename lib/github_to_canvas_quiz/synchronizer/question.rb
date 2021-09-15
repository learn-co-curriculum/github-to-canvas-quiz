# frozen_string_literal: true

module GithubToCanvasQuiz
  module Synchronizer
    class Question
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def sync(path)
        raise GithubToCanvasQuiz::FileNotFoundError unless File.exist? path

        question = load_question(path)
        # if the question doesn't have a course_id or quiz_id, load it from the README.md
        unless question.course_id && question.quiz_id
          quiz = load_quiz(path)
          question.quiz_id = quiz.id
          question.course_id = quiz.course_id
        end
        canvas_question = save_to_canvas(question)
        if question.id != canvas_question['id']
          question.id = canvas_question['id']
          update_readme(path, question)
        end
        question
      end

      private

      def load_quiz(path)
        readme_path = Pathname.new(path).parent.parent.join('README.md')
        md = File.read(readme_path)
        GithubToCanvasQuiz::Converter::Quiz.from_markdown(md)
      end

      def load_question(path)
        md = File.read(path)
        GithubToCanvasQuiz::Converter::Question.from_markdown(md)
      end

      def save_to_canvas(question)
        if question.id
          client.update_question(question.course_id, question.quiz_id, question.id, { 'question' => question.to_h })
        else
          client.create_question(question.course_id, question.quiz_id, { 'question' => question.to_h })
        end
      end

      # TODO: only update frontmatter?
      def update_readme(path, question)
        File.write(path, question.to_markdown)
      end
    end
  end
end
