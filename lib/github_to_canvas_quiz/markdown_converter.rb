# frozen_string_literal: true

module GithubToCanvasQuiz
  # Custom HTML renderer for Redcarpet, using Rouge for syntax highlighting
  class HTMLRenderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end

  # Convert a string of Markdown to HTML using Redcarpet and Rouge.
  #
  # Useage:
  #
  #   MarkdownConverter.new("# Hello\n\nWorld\n").to_html
  #   # => "<h1>Hello</h1>\n\n<p>World</p>\n"
  class MarkdownConverter
    attr_reader :options, :markdown

    OPTIONS = {
      tables: true,
      autolink: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
      no_intra_emphasis: true
    }.freeze

    # @param [String] markdown The markdown to be converted
    # @param [Hash] options Overrides the defaults for the [Redcarpet](https://github.com/vmg/redcarpet) gem
    def initialize(markdown, options = {})
      @options = OPTIONS.merge(options)
      @markdown = markdown
    end

    # @return [String] the markdown converted to HTML
    def to_html
      Redcarpet::Markdown.new(renderer, options).render(markdown)
    end

    private

    def renderer
      HTMLRenderer.new(escape_html: true)
    end
  end
end
