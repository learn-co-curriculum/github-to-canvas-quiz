# frozen_string_literal: true

module GithubToCanvasQuiz
  class RepoBuilder
    attr_reader :quiz, :questions

    def initialize(quiz, questions)
      @quiz = quiz
      @questions = questions
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
  end
end
