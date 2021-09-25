# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Markdown
      module Answer
        class FillInMultipleBlanks < Base
          def parse
            text, blank_id = parse_text_from_nodes(answer_nodes, 'li')
            Model::Answer::FillInMultipleBlanks.new(
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
