# frozen_string_literal: true

module GithubToCanvasQuiz
  class CustomRender < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end

  class MarkdownConverter
    attr_reader :markdown, :options

    def initialize(markdown)
      @markdown = markdown
      @options = {
        tables: true,
        autolink: true,
        fenced_code_blocks: true,
        disable_indented_code_blocks: true,
        no_intra_emphasis: true
      }
    end

    def to_html
      renderer = CustomRender.new(escape_html: true)
      Redcarpet::Markdown.new(renderer, options).render(markdown)
    end
  end
end
