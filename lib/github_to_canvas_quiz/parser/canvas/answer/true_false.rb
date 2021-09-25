# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Canvas
      module Answer
        class TrueFalse < Base
          def parse
            Model::Answer::TrueFalse.new(
              title: title,
              text: data['text'],
              comments: comments
            )
          end

          private

          def title
            data.fetch('weight', 0).positive? ? 'Correct' : 'Incorrect'
          end

          def comments
            choose_text(data.fetch('comments', ''), data.fetch('comments_html', ''))
          end
        end
      end
    end
  end
end
