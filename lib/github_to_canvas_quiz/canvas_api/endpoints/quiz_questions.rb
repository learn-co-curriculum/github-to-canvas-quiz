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

        def update_question(course_id, quiz_id, id, payload)
          put("/courses/#{course_id}/quizzes/#{quiz_id}/questions/#{id}", payload)
        end

        def delete_question(course_id, quiz_id, id)
          delete("/courses/#{course_id}/quizzes/#{quiz_id}/questions/#{id}")
        end
      end
    end
  end
end
