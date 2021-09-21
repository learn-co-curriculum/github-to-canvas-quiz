# frozen_string_literal: true

module GithubToCanvasQuiz
  module MarkdownParser
    class Base
      attr_reader :frontmatter, :scanner

      def initialize(markdown)
        parsed = FrontMatterParser::Parser.new(:md).call(markdown)
        html = MarkdownConverter.new(parsed.content).to_html

        @frontmatter = parsed.front_matter
        @scanner = HTML::Scanner.from_html(html)
      end
    end
  end
end
