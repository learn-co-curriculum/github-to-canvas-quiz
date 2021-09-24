# frozen_string_literal: true

module GithubToCanvasQuiz
  # CanvasAPI => Markdown
  module Builder
    # Create markdown files from a Canvas Quiz
    class Quiz
      attr_reader :client, :course_id, :quiz_id

      def initialize(client, course_id, quiz_id)
        @client = client
        @course_id = course_id
        @quiz_id = quiz_id
      end

      def build(path = '.')
        raise DirectoryNotFoundError unless File.directory? path

        File.write("#{path}/README.md", quiz.to_markdown)

        Dir.mkdir("#{path}/questions") unless File.directory? "#{path}/questions"
        questions.each.with_index do |question, index|
          filename = index.to_s.rjust(2, '0')
          File.write("#{path}/questions/#{filename}.md", question.to_markdown)
        end
      end

      private

      # Get quiz data from the Canvas API and return a Model::Quiz
      # memoized to prevent unnecessary API calls
      def quiz
        return @quiz if defined? @quiz

        @quiz = begin
          quiz_data = client.get_single_quiz(course_id, quiz_id)
          quiz_data.merge!({ 'course_id' => course_id })
          Parser::Canvas::Quiz.new(quiz_data).parse
        end
      end

      # Get question data from the Canvas API and return an array of Model::Question
      # memoized to prevent unnecessary API calls
      def questions
        return @questions if defined? @questions

        @questions = begin
          questions_data = client.list_questions(course_id, quiz_id)
          questions_data.map do |question_data|
            question_data.merge!({ 'course_id' => course_id, 'quiz_id' => quiz_id })
            Parser::Canvas::Question.new(question_data).parse
          end
        end
      end
    end
  end
end
