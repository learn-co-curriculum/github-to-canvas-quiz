# frozen_string_literal: true

module GithubToCanvasQuiz
  # Loosely based on the Ruby StringScanner class
  # Allows position-based traversal of a Nokogiri NodeSet
  module HTML
    class Scanner
      class << self
        def from_html(html)
          new(Nokogiri::HTML5.fragment(html).children)
        end
      end

      attr_reader :nodes
      attr_accessor :cursor

      def initialize(nodes)
        @nodes = nodes
        @cursor = 0
      end

      # returns whether or not we are at the end of the node list
      def eof?
        cursor >= nodes.length
      end

      # returns the node at the current cursor position
      def current
        nodes[cursor]
      end

      # scans until the node matching the selector is reached
      # updates the cursor position to the index **after** the found node
      # returns the found node
      def scan(selector)
        return unless nodes[cursor].matches?(selector)

        self.cursor += 1
        nodes[cursor - 1]
      end

      # scans until the node matching the selector is reached
      # updates the cursor position to the index **after** the matched node
      # returns nodes between the previous cursor position and the found node
      def scan_until(selector)
        scan_cursor = cursor
        while scan_cursor < nodes.length
          if nodes[scan_cursor].matches?(selector)
            found_nodes = nodes[cursor..scan_cursor]
            self.cursor = scan_cursor + 1
            return found_nodes
          end

          scan_cursor += 1
        end
      end

      # scans until the node matching the selector is reached
      # updates the cursor position to the index **of** the matched node
      # returns nodes between the previous cursor position and **before** the found node
      def scan_before(selector)
        scan_cursor = cursor + 1
        while scan_cursor < nodes.length
          if nodes[scan_cursor].matches?(selector)
            found_nodes = nodes[cursor..scan_cursor - 1]
            self.cursor = scan_cursor
            return found_nodes
          end

          scan_cursor += 1
        end
      end

      # scans until the end of the node set
      # updates the cursor position
      # returns the nodes between the cursor position and the end
      def scan_rest
        found_nodes = nodes[cursor..nodes.length - 1]
        self.cursor = nodes.length
        found_nodes
      end

      # checks if the current node matches the selector
      # does not update the cursor position
      def check(selector)
        return if eof? || !current.matches?(selector)

        current
      end

      # checks nodes until the node matching the selector is reached
      # does not update the cursor position
      # returns nodes between the cursor position and the found node
      def check_until(selector)
        scan_cursor = cursor
        while scan_cursor < nodes.length
          if nodes[scan_cursor].matches?(selector)
            found_nodes = nodes[cursor..scan_cursor]
            return found_nodes
          end

          scan_cursor += 1
        end
      end
    end
  end
end
