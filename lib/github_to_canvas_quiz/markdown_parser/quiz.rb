# frozen_string_literal: true

module GithubToCanvasQuiz
  module MarkdownParser
    class Quiz < Base
      attr_accessor :course_id, :id, :title, :description

      def parse
        read_frontmatter!
        scan_heading!

        to_h
      end

      def to_h
        {
          course_id: course_id,
          id: id,
          title: title,
          description: description
        }
      end

      private

      def read_frontmatter!
        frontmatter.each do |key, value|
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end

      def scan_heading!
        # Title - contents of first H1
        quiz_heading = scanner.scan_until('h1').last
        self.title = quiz_heading.content

        # Description - rest of document
        self.description = scanner.scan_rest.to_html.strip
      end
    end
  end
end
