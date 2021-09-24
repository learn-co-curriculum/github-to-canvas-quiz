# frozen_string_literal: true

require 'pry'

module GithubToCanvasQuiz
  module Parser
    module Markdown
      module Answer
        class Base
          include Helpers::NodeParser

          attr_reader :answer_nodes, :comment, :title

          def initialize(title, nodes)
            @title = title
            scanner = Helpers::NodeScanner.new(nodes)
            binding.pry
            @answer_nodes = scanner.scan_before('blockquote') || scanner.scan_rest
            @comment = scanner.eof? ? '' : scanner.scan_rest.to_html.strip
          end
        end

        class FillInMultipleBlanks < Base
          def call
            text, blank_id = parse_text_from_nodes(answer_nodes, 'li')
            Model::Answer::FillInMultipleBlanks.new(title: title, text: text, comments: comment, blank_id: blank_id)
          end
        end

        class Matching < Base
          def call
            left, right = parse_text_from_nodes(answer_nodes, 'li')
            Model::Answer::Matching.new(title: title, left: left, right: right, text: left, comments: comment)
          end
        end

        class MultipleAnswers < Base
          def call
            text = answer_nodes.to_html.strip
            Model::Answer::MultipleAnswers.new(title: title, text: text, comments: comment)
          end
        end

        class MultipleChoice < Base
          def call
            text = answer_nodes.to_html.strip
            Model::Answer::MultipleChoice.new(title: title, text: text, comments: comment)
          end
        end

        class ShortAnswer < Base
          def call
            text = parse_text_from_nodes(answer_nodes, 'p').first
            Model::Answer::ShortAnswer.new(title: title, text: text, comments: comment)
          end
        end

        class TrueFalse < Base
          def call
            text = parse_text_from_nodes(answer_nodes, 'p').first
            Model::Answer::TrueFalse.new(title: title, text: text, comments: comment)
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

        def self.for(type, title, nodes)
          CLASSES[type].new(title, nodes).call
        end
      end
    end
  end
end
