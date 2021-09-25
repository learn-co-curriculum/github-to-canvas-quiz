# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Markdown
      module Answer
        class MultipleDropdowns < Base
          def parse
            text, blank_id = parse_text_from_nodes(answer_nodes, 'li')
            Model::Answer::MultipleDropdowns.new(
              title: title,
              text: text,
              comments: comment,
              blank_id: blank_id
            )
          end
        end
      end
    end
  end
end
