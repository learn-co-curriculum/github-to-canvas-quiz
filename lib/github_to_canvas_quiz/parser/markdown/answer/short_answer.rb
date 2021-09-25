# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Markdown
      module Answer
        class ShortAnswer < Base
          def parse
            text = parse_text_from_nodes(answer_nodes, 'p').first

            Model::Answer::ShortAnswer.new(
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
