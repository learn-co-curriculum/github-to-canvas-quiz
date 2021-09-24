# frozen_string_literal: true

module GithubToCanvasQuiz
  class HTMLRenderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end

  class MarkdownConverter
    attr_reader :options, :markdown

    OPTIONS = {
      tables: true,
      autolink: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
      no_intra_emphasis: true
    }.freeze

    # Convert markdown to HTML
    def initialize(markdown, options = {})
      @options = OPTIONS.merge(options)
      @markdown = markdown
    end

    def to_html
      Redcarpet::Markdown.new(renderer, options).render(markdown)
    end

    def renderer
      HTMLRenderer.new(escape_html: true)
    end
  end
end
