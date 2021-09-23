# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Markdown
      class HTMLRenderer < Redcarpet::Render::HTML
        include Rouge::Plugins::Redcarpet
      end

      class Base
        include Helpers

        attr_reader :frontmatter, :html

        OPTIONS = {
          tables: true,
          autolink: true,
          fenced_code_blocks: true,
          disable_indented_code_blocks: true,
          no_intra_emphasis: true
        }.freeze

        def initialize(markdown, options = {})
          # Separate the frontmatter and the rest of the markdown content
          parsed = FrontMatterParser::Parser.new(:md).call(markdown)
          @frontmatter = parsed.front_matter

          # Convert markdown to HTML
          renderer = HTMLRenderer.new(escape_html: true)
          @html = Redcarpet::Markdown.new(renderer, OPTIONS.merge(options)).render(parsed.content)
        end

        def scanner
          @scanner ||= HTML::Scanner.from_html(html)
        end
      end
    end
  end
end
