# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Canvas
      module Answer
        class Base
          def initialize(data)
            @data = data
          end

          protected

          def choose_text(text, html)
            html.empty? ? text : html
          end

          private

          attr_reader :data
        end

        class FillInMultipleBlanks < Base
          def call
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

        class Matching < Base
          def call
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

        class MultipleAnswers < Base
          def call
            Model::Answer::MultipleAnswers.new(title: title, text: text, comments: comments)
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

        class MultipleChoice < Base
          def call
            Model::Answer::MultipleChoice.new(title: title, text: text, comments: comments)
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

        class ShortAnswer < Base
          def call
            Model::Answer::ShortAnswer.new(title: title, text: answer['text'], comments: comments)
          end

          private

          def title
            data.fetch('weight', 0).positive? ? 'Correct' : 'Incorrect'
          end

          def comments
            choose_text(data.fetch('comments', ''), data.fetch('comments_html', ''))
          end
        end

        class TrueFalse < Base
          def call
            Model::Answer::TrueFalse.new(title: title, text: answer['text'], comments: comments)
          end

          private

          def title
            data.fetch('weight', 0).positive? ? 'Correct' : 'Incorrect'
          end

          def comments
            choose_text(data.fetch('comments', ''), data.fetch('comments_html', ''))
          end
        end

        CLASSES = {
          'fill_in_multiple_blanks_question' => FillInMultipleBlanks,
          'matching_question' => Matching,
          'multiple_answers_question' => MultipleAnswers,
          'multiple_choice_question' => MultipleChoice,
          'short_answer_question' => ShortAnswer,
          'true_false_question' => TrueFalse
        }.freeze

        def self.for(type, data)
          CLASSES[type].new(data).call
        end
      end
    end
  end
end
