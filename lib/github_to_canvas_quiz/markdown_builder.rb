# frozen_string_literal: true

module GithubToCanvasQuiz
  # Custom DSL for building a Markdown string
  class MarkdownBuilder

    # Provides a custom DSL for building a Markdown string
    # Usage:
    #
    #   MarkdownBuilder.build do |md|
    #     md.h1('Hello')
    #     md.ul('item 1', 'item 2')
    #     md.blockquote('comment')
    #   end
    #
    #   # => "# Hello\n\n- item 1\n- item 2\n\n> comment\n"
    def self.build
      raise ArgumentError, 'no block given' unless block_given?

      builder = new
      yield(builder)
      builder.to_s
    end

    attr_accessor :blocks

    def initialize
      @blocks = []
    end

    # @return [String] markdown produced by joining all blocks
    def to_s
      "#{blocks.join("\n\n")}\n"
    end

    # Adds a frontmatter block
    # @param hash [Hash] the data to covert to YAML for the frontmatter
    def frontmatter(hash)
      blocks << "#{hash.to_yaml.strip}\n---"
    end

    # Adds a H1 heading
    # @param text [String] heading text
    def h1(text)
      blocks << "# #{text}"
    end

    # Adds a H2 heading
    # @param text [String] heading text
    def h2(text)
      blocks << "## #{text}"
    end

    # Adds a paragraph
    # @param text [String] paragraph text
    def p(text)
      blocks << escape(text)
    end

    # Adds a blockquote
    # @param text [String] blockquote text
    def blockquote(text)
      text = text.gsub("\n", "\n> ")
      blocks << "> #{text}"
    end

    # Adds multiple list items
    # @param texts* [Strings] a list of text to convert to list items
    def ul(*texts)
      blocks << texts.map { |text| "- #{escape(text)}" }.join("\n")
    end

    # Adds a block of arbitrary markdown
    # @param markdown [String] markdown string
    def md(markdown)
      blocks << markdown.strip
    end

    # TODO: This doesn't belong here...
    def html_to_markdown(html)
      ReverseMarkdown.convert(html, github_flavored: true).strip
    end

    private

    # TODO: What needs escaping??
    def escape(text)
      text.gsub('_', '\_')
    end
  end
end
