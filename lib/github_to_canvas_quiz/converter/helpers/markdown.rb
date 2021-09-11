# frozen_string_literal: true

module GithubToCanvasQuiz
  module Converter
    module Helpers
      module Markdown
        def frontmatter(hash)
          "#{hash.to_yaml.strip}\n---"
        end

        def h1(text)
          "# #{escape(text)}"
        end

        def h2(text)
          "## #{escape(text)}"
        end

        def ul(*texts)
          texts.map { |text| li(text) }.join("\n")
        end

        def li(text)
          "- #{escape(text)}"
        end

        def blockquote(html)
          md = markdown_block(html).strip.gsub("\n", "\n> ")
          "> #{md}"
        end

        def escape(text)
          text.gsub('_', '\_')
        end

        def markdown_block(html)
          markdown = ReverseMarkdown.convert(html, github_flavored: true)
          remove_canvas_cruft(markdown)
        end

        def join(markdown_blocks)
          output = markdown_blocks.map(&:strip).join("\n\n")
          output << "\n"
          output
        end

        def remove_canvas_cruft(markdown)
          markdown.gsub('&nbsp;(Links to an external site.)', '')
                  .gsub('&nbsp;', ' ')
        end
      end
    end
  end
end
