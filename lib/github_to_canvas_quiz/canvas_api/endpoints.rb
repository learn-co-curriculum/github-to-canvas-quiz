# frozen_string_literal: true

require_relative 'endpoints/quizzes'
require_relative 'endpoints/quiz_questions'

module GithubToCanvasQuiz
  module CanvasAPI
    module Endpoints
      include Quizzes
      include QuizQuestions
    end
  end
end
