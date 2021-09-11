# frozen_string_literal: true

# API
require 'rest-client'
require 'json'
require_relative 'github_to_canvas_quiz/canvas_api/endpoints'
require_relative 'github_to_canvas_quiz/canvas_api/client'

# Converters
require 'yaml'
require 'reverse_markdown'
require_relative 'github_to_canvas_quiz/converter/helpers/markdown'
require_relative 'github_to_canvas_quiz/converter/answer'
require_relative 'github_to_canvas_quiz/converter/quiz'
require_relative 'github_to_canvas_quiz/converter/question'

require_relative 'github_to_canvas_quiz/version'

module GithubToCanvasQuiz
  class Error < StandardError; end

  # Public API
  def self.create_repo_from_quiz(course_id, quiz_id)
    # TODO: CLI method?
    # get the quiz data from Canvas (with question data)
    client = CanvasAPI::Client.new(api_key: ENV['CANVAS_API_KEY'], host: ENV['CANVAS_API_PATH'])
    quiz_data = client.get_single_quiz(course_id, quiz_id)
    questions = client.list_questions(course_id, quiz_id)
    # convert the quiz data to markdown, including any metadata, and output
    quiz_md = Converter::Quiz.from_canvas(course_id, quiz_data).to_markdown
    File.write('tmp/README.md', quiz_md)
    questions.each_with_index do |question, index|
      question_md = Converter::Question.from_canvas(question).to_markdown
      filename = index.to_s.rjust(2, '0')
      File.write("tmp/questions/#{filename}.md", question_md)
    end
  end
end
