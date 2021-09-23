# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Markdown
      module Helpers
        def parse_text_from_nodes(nodes, selector)
          nodes.css(selector).map do |node|
            parse_text_from_node(node)
          end
        end

        def parse_text_from_node(node)
          CGI.unescapeHTML(node.content).strip
        end
      end
    end
  end
end
