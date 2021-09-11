# frozen_string_literal: true

module GithubToCanvasQuiz
  module Converter
    class Quiz
      class << self
        def from_canvas(course_id, data)
          new(
            course_id: course_id,
            id: data['id'],
            title: data['title'],
            description: data['description']
          )
        end
      end

      include Helpers::Markdown

      attr_accessor :course_id, :id, :title, :description

      def initialize(options)
        options.each do |key, value|
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end

      def to_markdown
        blocks = []
        blocks << frontmatter({
          'id' => id,
          'course_id' => course_id
        })
        blocks << h1(title)
        blocks << markdown_block(description)
        join(blocks)
      end
    end
  end
end
