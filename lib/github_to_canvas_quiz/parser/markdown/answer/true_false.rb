# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Markdown
      module Answer
        class TrueFalse < Base
          def parse
            text = parse_text_from_nodes(answer_nodes, 'p').first

            Model::Answer::TrueFalse.new(
              title: title,
              text: text,
              comments: comment
            )
          end
        end
      end
    end
  end
end
