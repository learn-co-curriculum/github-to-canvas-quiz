# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Markdown
      module Answer
        class Base
          include Helpers::NodeParser

          attr_reader :answer_nodes, :comment, :title

          def initialize(title, nodes)
            @title = title
            scanner = Helpers::NodeScanner.new(nodes)
            @answer_nodes = scanner.scan_before('blockquote') || scanner.scan_rest
            @comment = scanner.eof? ? '' : scanner.scan_rest.first.inner_html.strip
          end
        end
      end
    end
  end
end
