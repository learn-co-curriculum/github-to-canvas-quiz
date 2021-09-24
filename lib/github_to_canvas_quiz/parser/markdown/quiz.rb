# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Markdown
      # Parses a markdown file and returns a Quiz
      class Quiz < Base
        include Helpers::NodeParser

        def parse
          Model::Quiz.new(
            course_id: frontmatter['course_id'],
            id: frontmatter['id'],
            title: title,
            description: description
          )
        end

        private

        # Convert the markdown to HTML for scanning
        def html
          @html ||= MarkdownConverter.new(markdown).to_html
        end

        # Title - contents of first H1
        def title
          scanner = Helpers::NodeScanner.from_html(html)
          scanner.scan_until('h1').last.content
        end

        # Description - rest of document after the first H1
        def description
          scanner = Helpers::NodeScanner.from_html(html)
          scanner.scan_until('h1')
          scanner.scan_rest.to_html.strip
        end
      end
    end
  end
end
