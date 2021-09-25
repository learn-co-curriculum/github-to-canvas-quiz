# frozen_string_literal: true

require_relative 'answer/base'
require_relative 'answer/fill_in_multiple_blanks'
require_relative 'answer/matching'
require_relative 'answer/multiple_answers'
require_relative 'answer/multiple_choice'
require_relative 'answer/short_answer'
require_relative 'answer/true_false'

module GithubToCanvasQuiz
  module Parser
    module Canvas
      module Answer
        CLASSES = {
          'fill_in_multiple_blanks_question' => FillInMultipleBlanks,
          'matching_question' => Matching,
          'multiple_answers_question' => MultipleAnswers,
          'multiple_choice_question' => MultipleChoice,
          'short_answer_question' => ShortAnswer,
          'true_false_question' => TrueFalse
        }.freeze

        def self.for(type, data)
          raise UnknownQuestionType, type unless CLASSES.key?(type)

          CLASSES[type].new(data).parse
        end
      end
    end
  end
end
