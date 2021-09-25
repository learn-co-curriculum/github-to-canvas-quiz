# frozen_string_literal: true

module GithubToCanvasQuiz
  module CanvasAPI
    module Endpoints
      module Quizzes
        def list_quizzes(course_id)
          get_all("/courses/#{course_id}/quizzes")
        end

        def get_single_quiz(course_id, id)
          get("/courses/#{course_id}/quizzes/#{id}")
        end

        def create_quiz(course_id, payload)
          post("/courses/#{course_id}/quizzes", payload)
        end

        def update_quiz(course_id, id, payload)
          put("/courses/#{course_id}/quizzes/#{id}", payload)
        end
      end
    end
  end
end
