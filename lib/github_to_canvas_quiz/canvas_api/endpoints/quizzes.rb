# frozen_string_literal: true

module GithubToCanvasQuiz
  module CanvasAPI
    module Endpoints
      module Quizzes
        def get_single_quiz(course_id, id)
          get("/courses/#{course_id}/quizzes/#{id}")
        end

        def create_quiz(course_id, payload)
          post("/courses/#{course_id}/quizzes", payload)
        end
      end
    end
  end
end
