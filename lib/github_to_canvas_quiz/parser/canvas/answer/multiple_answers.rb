# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Canvas
      module Answer
        class MultipleAnswers < Base
          def parse
            Model::Answer::MultipleAnswers.new(
              title: title,
              text: text,
              comments: comments
            )
          end

          private

          def title
            data.fetch('weight', 0).positive? ? 'Correct' : 'Incorrect'
          end

          def text
            choose_text(data.fetch('text', ''), data.fetch('html', ''))
          end

          def comments
            choose_text(data.fetch('comments', ''), data.fetch('comments_html', ''))
          end
        end
      end
    end
  end
end
