# frozen_string_literal: true

module GithubToCanvasQuiz
  module Model
    class Question
      attr_accessor :course_id, :quiz_id, :id, :type, :sources, :name, :description, :answers, :distractors

      def initialize(options)
        options.each do |key, value|
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end

      def to_markdown
        MarkdownBuilder.build do |md|
          md.frontmatter(frontmatter_hash)
          md.h1(name)
          md.md(md.html_to_markdown(description))
          answers.each do |answer|
            md.md(answer.to_markdown)
          end
          unless distractors.empty?
            md.h2('Incorrect')
            md.ul(*distractors)
          end
        end
      end

      def to_h
        {
          'question_name' => name,
          'question_text' => description,
          'question_type' => type,
          'points_possible' => 1,
          'neutral_comments_html' => sources.nil? || sources.empty? ? '' : sources_to_html,
          'answers' => answers.map(&:to_h),
          'matching_answer_incorrect_matches' => distractors.join("\n")
        }
      end

      def frontmatter_hash
        {
          'course_id' => course_id,
          'quiz_id' => quiz_id,
          'id' => id,
          'type' => type,
          'sources' => sources
        }
      end

      private

      def sources_to_html
        comments = sources.map do |source|
          "<li><a href=\"#{source['url']}\">#{source['name']}</a></li>"
        end.join
        "<p><strong>Source/s:</strong><ul>#{comments}</ul></p>"
      end
    end
  end
end
