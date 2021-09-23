# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Canvas
      class Base
        attr_reader :client

        def initialize(client)
          @client = client
        end
      end
    end
  end
end
