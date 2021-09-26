# frozen_string_literal: true

module GithubToCanvasQuiz
  # CanvasAPI => Markdown
  module Builder
    # Create markdown files from a Canvas Quiz
    class Quiz
      attr_reader :client, :course_id, :quiz_id, :path

      def initialize(client, course_id, quiz_id, path = '.')
        @path = path
        @client = client
        @course_id = course_id
        @quiz_id = quiz_id
      end

      def build
        prepare_directory!
        save_quiz!
        save_questions!
        commit!
      end

      private

      def prepare_directory!
        Dir.mkdir(path) unless Pathname(path).directory?
      end

      def save_quiz!
        File.write(quiz_readme_path, quiz.to_markdown)
      end

      def save_questions!
        Dir.mkdir(questions_path) unless Pathname(questions_path).directory?
        questions.each.with_index do |question, index|
          File.write(question_readme_path(index), question.to_markdown)
        end
      end

      def commit!
        git = Git.init(path) # inits a new repo, or loads the current one
        git.add(['README.md', 'questions'])
        git.commit('Created quiz and questions')
      end

      def quiz_readme_path
        File.join(path, 'README.md')
      end

      def questions_path
        File.join(path, 'questions')
      end

      def question_readme_path(index)
        filename = "#{index.to_s.rjust(2, '0')}.md"
        File.join(questions_path, filename)
      end

      # Get quiz data from the Canvas API and return a Model::Quiz
      # memoized to prevent unnecessary API calls
      def quiz
        return @quiz if defined? @quiz

        @quiz = begin
          quiz = Parser::Canvas::Quiz.new(canvas_quiz_data).parse
          # use file path as repo if not present
          quiz.repo = path.split('/').last unless quiz.repo
          quiz
        end
      end

      def canvas_quiz_data
        quiz_data = client.get_single_quiz(course_id, quiz_id)
        quiz_data.merge({ 'course_id' => course_id })
      end

      # Get question data from the Canvas API and return an array of Model::Question
      # memoized to prevent unnecessary API calls
      def questions
        @questions ||= canvas_question_data.map do |question_data|
          Parser::Canvas::Question.new(question_data).parse
        end
      end

      def canvas_question_data
        questions_data = client.list_questions(course_id, quiz_id)
        questions_data.map do |question_data|
          question_data.merge({ 'course_id' => course_id, 'quiz_id' => quiz_id })
        end
      end
    end
  end
end
