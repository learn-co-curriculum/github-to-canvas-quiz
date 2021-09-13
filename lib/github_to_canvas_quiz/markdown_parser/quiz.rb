# frozen_string_literal: true

module GithubToCanvasQuiz
  module MarkdownParser
    class Quiz < Base
      def parse
        title = parse_title!
        description = parse_description!

        {
          course_id: frontmatter['course_id'],
          id: frontmatter['id'],
          title: title,
          description: description
        }
      end

      private

      def parse_title!
        src.scan(/<h1>(.*?)<\/h1>/)
        src.captures[0]
      end

      def parse_description!
        src.rest.strip
      end
    end
  end
end
