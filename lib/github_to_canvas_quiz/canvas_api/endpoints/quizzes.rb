# frozen_string_literal: true

module GithubToCanvasQuiz
  module CanvasAPI
    module Endpoints
      module Quizzes
        def get_single_quiz(course_id, id)
          get("/courses/#{course_id}/quizzes/#{id}")
        end
      end
    end
  end
end
