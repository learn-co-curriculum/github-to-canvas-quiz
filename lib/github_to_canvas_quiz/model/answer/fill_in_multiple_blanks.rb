# frozen_string_literal: true

module GithubToCanvasQuiz
  module Model
    module Answer
      class FillInMultipleBlanks
        attr_accessor :id, :title, :text, :comments, :blank_id

        def initialize(options)
          options.each do |key, value|
            send("#{key}=", value) if respond_to?("#{key}=")
          end
        end

        def to_markdown
          MarkdownBuilder.build do |md|
            md.h2(title)
            md.ul(text, blank_id)
            md.blockquote(md.html_to_markdown(comments)) unless comments.empty?
          end
        end

        def to_h
          {
            'answer_text' => text,
            'answer_weight' => title == 'Correct' ? 100 : 0,
            'answer_comment_html' => comments,
            'blank_id' => blank_id,
            'id' => id
          }.reject { |_,v| v.nil? }
        end
      end
    end
  end
end
