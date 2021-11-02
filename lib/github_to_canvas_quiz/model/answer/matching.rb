# frozen_string_literal: true

module GithubToCanvasQuiz
  module Model
    module Answer
      class Matching
        attr_accessor :id, :title, :text, :comments, :left, :right

        def initialize(options)
          options.each do |key, value|
            send("#{key}=", value) if respond_to?("#{key}=")
          end
        end

        def to_markdown
          MarkdownBuilder.build do |md|
            md.h2(title)
            md.ul(left, right)
            md.blockquote(md.html_to_markdown(comments)) unless comments.empty?
          end
        end

        def to_h
          {
            'answer_text' => left,
            'answer_weight' => 100,
            'answer_comment_html' => comments,
            'answer_match_left' => left,
            'answer_match_right' => right,
            'id' => id
          }.reject { |_,v| v.nil? }
        end
      end
    end
  end
end
