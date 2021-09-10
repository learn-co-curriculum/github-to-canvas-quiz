# frozen_string_literal: true

# API
require 'rest-client'
require 'json'
require_relative 'github_to_canvas_quiz/canvas_api/endpoints'
require_relative 'github_to_canvas_quiz/canvas_api/client'

require_relative 'github_to_canvas_quiz/version'

module GithubToCanvasQuiz
  class Error < StandardError; end

  # Public API
  def self.create_repo_from_quiz(course_id, quiz_id)
    # get the quiz data from Canvas (with question data)
    # convert the quiz data to markdown, including any metadata
    # output files???
  end

end
