# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Markdown
      module Answer
        class MultipleAnswers < Base
          def parse
            text = answer_nodes.to_html.strip

            Model::Answer::MultipleAnswers.new(
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
