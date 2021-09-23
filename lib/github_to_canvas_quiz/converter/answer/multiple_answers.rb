# frozen_string_literal: true

module GithubToCanvasQuiz
  module Converter
    module Answer
      class MultipleAnswers
        class << self
          def from_canvas(data)
            new(
              title: data.fetch('weight', 0).positive? ? 'Correct' : 'Incorrect',
              text: choose_text(data.fetch('text', ''), data.fetch('html', '')),
              comments: choose_text(data.fetch('comments', ''), data.fetch('comments_html', ''))
            )
          end

          private

          def choose_text(text, html)
            html.empty? ? text : html
          end
        end

        attr_accessor :title, :text, :comments

        def initialize(options)
          options.each do |key, value|
            send("#{key}=", value) if respond_to?("#{key}=")
          end
        end

        def to_markdown
          MarkdownBuilder.new.build do |md|
            md.h2(title)
            md.from_html(text)
            md.blockquote(comments) unless comments.empty?
          end
        end

        def to_h
          {
            'answer_html' => text,
            'answer_weight' => title == 'Correct' ? 100 : 0,
            'answer_comment_html' => comments
          }
        end
      end
    end
  end
end
