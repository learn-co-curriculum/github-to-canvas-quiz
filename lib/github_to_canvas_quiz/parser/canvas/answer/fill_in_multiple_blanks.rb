# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Canvas
      module Answer
        class FillInMultipleBlanks < Base
          def parse
            Model::Answer::FillInMultipleBlanks.new(
              title: title,
              text: data['text'],
              comments: comments,
              blank_id: data['blank_id']
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
