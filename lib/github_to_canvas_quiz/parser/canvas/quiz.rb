# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Canvas
      # Parses a quiz from the Canvas API and returns a Quiz
      class Quiz < Base
        def parse
          Model::Quiz.new(
            course_id: data['course_id'],
            id: data['id'],
            title: data['title'],
            description: data['description']
          )
        end
      end
    end
  end
end
