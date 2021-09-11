# frozen_string_literal: true

module GithubToCanvasQuiz
  module Converter
    class Question
      class << self
        def from_canvas(data)
          new(
            id: data['id'],
            type: data['question_type'],
            name: data['question_name'],
            description: data['question_text'],
            comment: data['neutral_comments_html'],
            answers: data['answers']
          )
        end
      end

      include Helpers::Markdown

      attr_accessor :id, :type, :name, :description, :comment, :answers

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
        join(blocks)
      end
    end
  end
end
