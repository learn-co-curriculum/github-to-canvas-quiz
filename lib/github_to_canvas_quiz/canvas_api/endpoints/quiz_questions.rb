# frozen_string_literal: true

module GithubToCanvasQuiz
  module CanvasAPI
    module Endpoints
      module QuizQuestions
        def list_questions(course_id, quiz_id)
          get("/courses/#{course_id}/quizzes/#{quiz_id}/questions")
        end
      end
    end
  end
end
