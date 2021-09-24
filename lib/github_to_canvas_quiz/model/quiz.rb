# frozen_string_literal: true

module GithubToCanvasQuiz
  module Model
    class Quiz
      attr_accessor :course_id, :id, :title, :description

      def initialize(options)
        options.each do |key, value|
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end

      def to_markdown
        MarkdownBuilder.new.build do |md|
          md.frontmatter(frontmatter_hash)
          md.h1(title)
          md.from_html(description)
        end
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

      private

      def frontmatter_hash
        {
          'id' => id,
          'course_id' => course_id
        }
      end
    end
  end
end
