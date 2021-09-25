# frozen_string_literal: true

module GithubToCanvasQuiz
  class MarkdownBuilder
    attr_accessor :blocks

    def initialize
      @blocks = []
    end

    def build
      yield(self)
      "#{blocks.join("\n\n")}\n"
    end

    def frontmatter(hash)
      blocks << "#{hash.to_yaml.strip}\n---"
    end

    def h1(text)
      blocks << "# #{escape(text)}"
    end

    def h2(text)
      blocks << "## #{escape(text)}"
    end

    def ul(*texts)
      blocks << texts.map { |text| "- #{escape(text)}" }.join("\n")
    end

    def blockquote(html)
      md = html_to_markdown(html).gsub("\n", "\n> ")
      blocks << "> #{md}"
    end

    def from_html(html)
      blocks << html_to_markdown(html)
    end

    def add_markdown(markdown)
      blocks << markdown.strip
    end

    private

    def escape(text)
      text.gsub('_', '\_')
    end

    def html_to_markdown(html)
      ReverseMarkdown.convert(html, github_flavored: true).strip
    end
  end
end
