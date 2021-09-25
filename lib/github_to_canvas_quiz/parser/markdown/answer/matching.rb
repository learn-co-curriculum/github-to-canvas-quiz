# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Markdown
      module Answer
        class Matching < Base
          def parse
            left, right = parse_text_from_nodes(answer_nodes, 'li')

            Model::Answer::Matching.new(
              title: title,
              left: left,
              right: right,
              text: left,
              comments: comment
            )
          end
        end
      end
    end
  end
end
