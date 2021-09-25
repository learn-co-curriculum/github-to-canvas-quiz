# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Markdown
      module Answer
        class MultipleChoice < Base
          def parse
            Model::Answer::MultipleChoice.new(
              title: title,
              text: answer_nodes.to_html.strip,
              comments: comment
            )
          end
        end
      end
    end
  end
end
