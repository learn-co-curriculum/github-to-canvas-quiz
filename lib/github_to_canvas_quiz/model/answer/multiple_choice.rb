# frozen_string_literal: true

module GithubToCanvasQuiz
  module Model
    module Answer
      class MultipleChoice
        attr_accessor :title, :text, :comments

        def initialize(options)
          options.each do |key, value|
            send("#{key}=", value) if respond_to?("#{key}=")
          end
        end

        def to_markdown
          MarkdownBuilder.build do |md|
            md.h2(title)
            md.md(md.html_to_markdown(text))
            md.blockquote(md.html_to_markdown(comments)) unless comments.empty?
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
