# frozen_string_literal: true

module GithubToCanvasQuiz
  module Model
    module Answer
      class TrueFalse
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
            'answer_text' => text,
            'answer_weight' => title == 'Correct' ? 100 : 0,
            'answer_comment_html' => comments
          }
        end
      end
    end
  end
end
