# frozen_string_literal: true

module GithubToCanvasQuiz
  module Converter
    class Answer
      include Helpers::Markdown

      class << self
        def from_canvas(data)
          new(
            text: choose_text(data.fetch('text', ''), data.fetch('html', '')),
            comments: choose_text(data.fetch('comments', ''), data.fetch('comments_html', '')),
            left: data.fetch('left', ''),
            right: data.fetch('right', ''),
            title: choose_title(data.fetch('left', ''), data.fetch('weight', 0))
          )
        end

        private

        def choose_title(left, weight)
          !left.empty? || weight.positive? ? 'Correct' : 'Incorrect'
        end

        def choose_text(text, html)
          html.empty? ? text : html
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
        blocks << if left.empty?
                    markdown_block(text)
                  else
                    ul(left, right)
                  end
        blocks << blockquote(comments) unless comments.empty?
        join(blocks)
      end
    end
  end
end
