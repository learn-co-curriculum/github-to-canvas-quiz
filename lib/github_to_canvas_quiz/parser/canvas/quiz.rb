# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Canvas
      # Parses a quiz from the Canvas API and returns a Quiz
      class Quiz < Base
        def load(course_id, id)
          quiz_data = client.get_single_quiz(course_id, id)

          Model::Quiz.new(
            course_id: course_id,
            id: id,
            title: quiz_data['title'],
            description: quiz_data['description']
          )
        end
      end
    end
  end
end
