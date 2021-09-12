# frozen_string_literal: true

module GithubToCanvasQuiz
  module CanvasAPI
    module Endpoints
      module QuizQuestions
        def list_questions(course_id, quiz_id)
          get("/courses/#{course_id}/quizzes/#{quiz_id}/questions")
        end

        def create_question(course_id, quiz_id, payload)
          post("/courses/#{course_id}/quizzes/#{quiz_id}/questions", payload)
        end
      end
    end
  end
end
