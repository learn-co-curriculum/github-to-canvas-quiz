# frozen_string_literal: true

module GithubToCanvasQuiz
  module Converter
    class Quiz
      class << self
        def from_markdown(markdown)
          options = MarkdownParser::Quiz.new(markdown).parse
          new(options)
        end

        def from_canvas(course_id, data)
          new(
            course_id: course_id,
            id: data.fetch('id'),
            title: data.fetch('title'),
            description: data.fetch('description', '')
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

      def to_h
        {
          'title' => title,
          'description' => description,
          'quiz_type' => 'assignment',
          'shuffle_answers' => true,
          'hide_results' => 'until_after_last_attempt',
          'show_correct_answers_last_attempt' => true,
          'allowed_attempts' => 3,
          'scoring_policy' => 'keep_highest',
          'one_question_at_a_time' => true
        }
      end
    end
  end
end
