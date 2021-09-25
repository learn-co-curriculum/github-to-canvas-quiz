# frozen_string_literal: true

# Override p blocks to enable line wrapping
# https://github.com/xijo/reverse_markdown/blob/master/lib/reverse_markdown/converters/p.rb
module ReverseMarkdown
  module Converters
    class P < Base
      def convert(node, state = {})
        content = treat_children(node, state)
        "\n\n#{wrap(content).strip}\n\n"
      end

      private

      def wrap(text, width = 80)
        text.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
      end
    end
  end
end
