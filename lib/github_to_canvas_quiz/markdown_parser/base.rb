# frozen_string_literal: true

module GithubToCanvasQuiz
  module MarkdownParser
    class Base
      attr_reader :frontmatter, :src

      def initialize(markdown)
        @frontmatter, html = parse_markdown(markdown)
        @src = StringScanner.new(html)
      end

      private

      def parse_markdown(markdown)
        parsed = FrontMatterParser::Parser.new(:md).call(markdown)
        html = MarkdownConverter.new(parsed.content).to_html
        [parsed.front_matter, html]
      end

    end
  end
end
