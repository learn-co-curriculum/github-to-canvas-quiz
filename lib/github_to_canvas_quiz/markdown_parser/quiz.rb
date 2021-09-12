# frozen_string_literal: true

module GithubToCanvasQuiz
  module MarkdownParser
    class Quiz
      attr_reader :markdown

      def initialize(markdown)
        @markdown = markdown
      end

      def parse
        frontmatter, html = separate_frontmatter_and_html

        src = StringScanner.new(html)
        title = parse_title!(src)
        description = parse_description!(src)

        {
          course_id: frontmatter['course_id'],
          id: frontmatter['id'],
          title: title,
          description: description
        }
      end

      private

      def separate_frontmatter_and_html
        parsed = FrontMatterParser::Parser.new(:md).call(markdown)
        html = MarkdownConverter.new(parsed.content).to_html
        [parsed.front_matter, html]
      end

      def parse_title!(src)
        src.scan(/<h1>(.*?)<\/h1>/)
        src.captures[0]
      end

      def parse_description!(src)
        src.rest.strip
      end
    end
  end
end
