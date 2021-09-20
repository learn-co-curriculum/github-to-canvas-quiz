# frozen_string_literal: true

module GithubToCanvasQuiz
  module Converter
    module Answer
      class TrueFalse
        class << self
          def from_canvas(data)
            new(
              title: data.fetch('weight', 0).positive? ? 'Correct' : 'Incorrect',
              text: data['text'],
              comments: choose_text(data.fetch('comments', ''), data.fetch('comments_html', ''))
            )
          end

          private

          def choose_text(text, html)
            html.empty? ? text : html
          end
        end

        include Helpers::Markdown

        attr_accessor :title, :text, :comments

        def initialize(options)
          options.each do |key, value|
            send("#{key}=", value) if respond_to?("#{key}=")
          end
        end

        def to_markdown
          blocks = []
          blocks << h2(title)
          blocks << markdown_block(text)
          blocks << blockquote(comments) unless comments.empty?
          join(blocks)
        end

        def to_h
          {
            'answer_text' => text,
            'answer_weight' => title == 'Correct' ? 100 : 0,
            'answer_comment_html' => comments
          }
        end
      end
    end
  end
end
