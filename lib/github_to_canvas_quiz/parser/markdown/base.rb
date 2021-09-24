# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Markdown
      class Base
        attr_reader :frontmatter, :markdown

        def initialize(markdown)
          # Separate the frontmatter and the rest of the markdown content
          parsed = if Pathname(markdown).exist?
                     FrontMatterParser::Parser.parse_file(markdown)
                   else
                     FrontMatterParser::Parser.new(:md).call(markdown)
                   end
          @frontmatter = parsed.front_matter
          @markdown = parsed.content
        end
      end
    end
  end
end
