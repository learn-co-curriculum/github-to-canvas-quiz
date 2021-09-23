# frozen_string_literal: true

module GithubToCanvasQuiz
  module Converter
    module Answer
      class Matching
        class << self
          def from_canvas(data)
            new(
              title: data['left'].empty? ? 'Incorrect' : 'Correct',
              text: data['text'],
              comments: choose_text(data.fetch('comments', ''), data.fetch('comments_html', '')),
              left: data['left'],
              right: data['right']
            )
          end

          private

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
          MarkdownBuilder.new.build do |md|
            md.h2(title)
            md.ul(left, right)
            md.blockquote(comments) unless comments.empty?
          end
        end

        def to_h
          {
            'answer_text' => left,
            'answer_weight' => 100,
            'answer_comment_html' => comments,
            'answer_match_left' => left,
            'answer_match_right' => right
          }
        end
      end
    end
  end
end
