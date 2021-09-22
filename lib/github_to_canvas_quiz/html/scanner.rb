# frozen_string_literal: true

module GithubToCanvasQuiz
  module HTML
    # GithubToCanvasQuiz::HTML::Scanner
    #
    # Loosely based on the Ruby `StringScanner` class. allows position-based
    # traversal of a `Nokogiri::XML::NodeSet`:
    #
    #   html = '<h1>Hello</h1><h2>World</h2><h3>end.</h3>'
    #   scanner = HTML::Scanner.from_html(html)
    #
    #   # scan and return nodes before the first H3
    #   nodes = scanner.scan_before('h3')
    #   nodes.first.content # => 'Hello'
    #   nodes.last.content  # => 'World'
    #   scanner.cursor      # => 2
    #
    #   # scan the current node if it is a H3
    #   h3 = scanner.scan('h3')
    #   h3.content          # => 'end.'
    #   scanner.eof?        # => true
    class Scanner
      class << self
        #
        # Create a new Scanner from a HTML string. Generally, you'll use this instead of initializing the class directly.
        #
        # @param [String] html The string of HTML you wish to scan
        #
        # @return [GithubToCanvasQuiz::HTML::Scanner] The new Scanner instance
        def from_html(html)
          new(Nokogiri::HTML5.fragment(html).children)
        end
      end

      attr_reader :node_set
      attr_accessor :cursor

      #
      # Create a new instance from a Nokogiri::XML::NodeSet
      #
      # @param [Nokogiri::XML::NodeSet] node_set NodeSet to be scanned
      #
      def initialize(node_set)
        unless node_set.is_a? Nokogiri::XML::NodeSet
          raise TypeError, "expected a Nokogiri::XML::NodeSet, got #{node_set.class.name}"
        end

        @node_set = node_set
        @cursor = 0
      end

      # Returns whether or not the scanner is at the end of the `node_set`
      def eof?
        cursor >= node_set.length
      end

      # Returns the node at the current cursor position
      def current
        node_set[cursor]
      end

      # Scans the current node to see if it matches the selector. If it does,
      # update the cursor position to the index **after** the found node and
      # returns the found node. Otherwise, return `nil`.
      #
      #   html = '<h1>Hello</h1><h2>World</h2><h3>end.</h3>'
      #   scanner = HTML::Scanner.from_html(html)
      #
      #   h1 = scanner.scan('h1')
      #   h1.content     # => 'Hello'
      #   scanner.cursor # => 1
      def scan(selector)
        scanned_node = current
        return unless scanned_node.matches?(selector)

        self.cursor += 1
        scanned_node
      end

      # Scans until the node matching the selector is reached, and updates the
      # cursor position to the index **after** the matched node.
      #
      # Returns a `NodeSet` of all nodes between the previous cursor position
      # and the found node.
      #
      #   html = '<h1>Hello</h1><h2>World</h2><h3>end.</h3>'
      #   scanner = HTML::Scanner.from_html(html)
      #
      #   nodes = scanner.scan_until('h2')
      #   nodes.last.content  # => 'World'
      #   scanner.cursor      # => 2
      def scan_until(selector)
        scan_cursor = cursor
        while scan_cursor < node_set.length
          if node_set[scan_cursor].matches?(selector)
            found_nodes = node_set[cursor..scan_cursor]
            self.cursor = scan_cursor + 1
            return found_nodes
          end

          scan_cursor += 1
        end
      end

      # Scans until the node matching the selector is reached, and updates the
      # cursor position to the index **of** the matched node.
      #
      # Returns a `NodeSet` of all nodes between the previous cursor position
      # and **before** the found node.
      #
      #   html = '<h1>Hello</h1><h2>World</h2><h3>end.</h3>'
      #   scanner = HTML::Scanner.from_html(html)
      #
      #   nodes = scanner.scan_before('h2')
      #   nodes.last.content  # => 'Hello'
      #   scanner.cursor      # => 1
      def scan_before(selector)
        scan_cursor = cursor + 1
        while scan_cursor < node_set.length
          if node_set[scan_cursor].matches?(selector)
            found_nodes = node_set[cursor..scan_cursor - 1]
            self.cursor = scan_cursor
            return found_nodes
          end

          scan_cursor += 1
        end
      end

      # Scans until the end of the node set, and updates the cursor position to the end.
      # Returns a `NodeSet` of all the nodes between the cursor position and the end.
      #
      #   html = '<h1>Hello</h1><h2>World</h2><h3>end.</h3>'
      #   scanner = HTML::Scanner.from_html(html)
      #
      #   nodes = scanner.scan_before('h2')
      #   nodes.last.content  # => 'Hello'
      #   scanner.cursor      # => 1
      #   nodes = scanner.scan_rest
      #   nodes.last.content  # => 'end.
      #   scanner.cursor      # => 3
      def scan_rest
        found_nodes = node_set[cursor..node_set.length - 1]
        self.cursor = node_set.length
        found_nodes
      end

      # Does not update cursor. Checks the current node to see if it matches the selector.
      # If it does, returns the found node. Otherwise, returns `nil`.
      #
      #   html = '<h1>Hello</h1><h2>World</h2><h3>end.</h3>'
      #   scanner = HTML::Scanner.from_html(html)
      #
      #   h1 = scanner.check('h1')
      #   h1.content     # => 'Hello'
      #   scanner.cursor # => 0
      def check(selector)
        return if eof? || !current.matches?(selector)

        current
      end

      # Does not update cursor. Checks until the node matching the selector is reached, and
      # updates the cursor position to the index **after** the matched node.
      #
      # Returns a `NodeSet` of all nodes between the previous cursor position
      # and the found node.
      #
      #   html = '<h1>Hello</h1><h2>World</h2><h3>end.</h3>'
      #   scanner = HTML::Scanner.from_html(html)
      #
      #   nodes = scanner.check_until('h2')
      #   nodes.last.content  # => 'World'
      #   scanner.cursor      # => 0
      def check_until(selector)
        scan_cursor = cursor
        while scan_cursor < node_set.length
          if node_set[scan_cursor].matches?(selector)
            found_nodes = node_set[cursor..scan_cursor]
            return found_nodes
          end

          scan_cursor += 1
        end
      end

      # Does not update cursor. Checks until the node matching the selector is reached,
      # and updates the cursor position to the index **of** the matched node.
      #
      # Returns a `NodeSet` of all nodes between the previous cursor position
      # and **before** the found node.
      #
      #   html = '<h1>Hello</h1><h2>World</h2><h3>end.</h3>'
      #   scanner = HTML::Scanner.from_html(html)
      #
      #   nodes = scanner.check_before('h2')
      #   nodes.last.content  # => 'Hello'
      #   scanner.cursor      # => 0
      def check_before(selector)
        scan_cursor = cursor + 1
        while scan_cursor < node_set.length
          if node_set[scan_cursor].matches?(selector)
            found_nodes = node_set[cursor..scan_cursor - 1]
            self.cursor = scan_cursor
            return found_nodes
          end

          scan_cursor += 1
        end
      end
    end
  end
end
