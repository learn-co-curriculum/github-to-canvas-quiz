# frozen_string_literal: true

module GithubToCanvasQuiz
  module Converter
    class Answer
      include Helpers::Markdown

      class << self
        def from_canvas(data)
          new(
            text: choose_text(data['text'], data['html']),
            comments: choose_text(data['comments'], data['comments_html']),
            left: data['left'],
            right: data['right'],
            title: choose_title(data['left'], data['weight'])
          )
        end

        private

        def choose_title(left, weight)
          if (!left.nil? && !left.empty?) || weight.positive?
            'Correct'
          else
            'Incorrect'
          end
        end

        def choose_text(text, html)
          html.nil? || html.empty? ? text : html
        end
      end

      attr_accessor :title, :text, :comments, :left, :right

      def initialize(options)
        options.each do |key, value|
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end

      def to_markdown
        blocks = []
        blocks << h2(title)
        blocks << if matching_answer?
                    ul(left, right)
                  else
                    markdown_block(text)
                  end
        blocks << blockquote(comments) unless comments.nil? || comments.empty?
        join(blocks)
      end

      private

      def matching_answer?
        !left.nil? && !left.empty?
      end
    end
  end
end
