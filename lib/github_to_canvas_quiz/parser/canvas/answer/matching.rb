# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Canvas
      module Answer
        class Matching < Base
          def parse
            Model::Answer::Matching.new(
              title: title,
              text: data['text'],
              comments: comments,
              left: data['left'],
              right: data['right']
            )
          end

          private

          def title
            data['left'].empty? ? 'Incorrect' : 'Correct'
          end

          def comments
            choose_text(data.fetch('comments', ''), data.fetch('comments_html', ''))
          end
        end
      end
    end
  end
end
