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
        backup_canvas_to_json!
        commit!
      end

      private

      def repo
        @repo ||= RepositoryInterface.new(path)
      end

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

      def backup_canvas_to_json!
        quiz = client.get_single_quiz(course_id, quiz_id)
        questions = client.list_questions(course_id, quiz_id)

        json_data = JSON.pretty_generate({ quiz: quiz, questions: questions })
        File.write(json_path, json_data)
      end

      def commit!
        repo = RepositoryInterface.new(path)
        repo.commit_files('README.md', 'questions', '.canvas-snapshot.json', 'Created Canvas backup')
      end

      def json_path
        File.join(path, '.canvas-snapshot.json')
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
