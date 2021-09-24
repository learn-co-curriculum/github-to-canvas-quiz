# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Canvas
      class Base
        attr_reader :data

        def initialize(data)
          @data = data
        end
      end
    end
  end
end
