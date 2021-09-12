# frozen_string_literal: true

module GithubToCanvasQuiz
  module Converter
    class Question
      class << self
        def from_markdown(markdown)
          options = MarkdownParser::Question.new(markdown).parse
          options[:answers] = options[:answers].map do |answer|
            Answer.from_canvas(answer)
          end
          new(options)
        end

        def from_canvas(data)
          answers = data.fetch('answers', []).map do |answer|
            Answer.from_canvas(answer)
          end
          new(
            id: data.fetch('id'),
            type: data.fetch('question_type'),
            name: data.fetch('question_name', ''),
            description: data.fetch('question_text', ''),
            comment: data.fetch('neutral_comments_html', ''),
            answers: answers,
            distractors: data.fetch('matching_answer_incorrect_matches', '').split("\n")
          )
        end
      end

      include Helpers::Markdown

      attr_accessor :id, :type, :name, :description, :comment, :answers, :distractors

      def initialize(options)
        options.each do |key, value|
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end

      def to_markdown
        blocks = []
        blocks << frontmatter({
          'id' => id,
          'type' => type
        })
        blocks << h1(name)
        blocks << markdown_block(description)
        blocks << blockquote(comment) unless comment.empty?
        answers.each do |answer|
          blocks << Answer.from_canvas(answer).to_markdown
        end
        unless distractors.empty?
          blocks << h2('Incorrect')
          blocks << ul(*distractors)
        end
        join(blocks)
      end

      def to_h
        {
          'id' => id,
          'question' => {
            'question_name' => name,
            'question_text' => description,
            'question_type' => type,
            'points_possible' => 1,
            'neutral_comments_html' => comment,
            'answers' => answers.map(&:to_h),
            'matching_answer_incorrect_matches' => distractors.join("\n")
          }
        }
      end
    end
  end
end
