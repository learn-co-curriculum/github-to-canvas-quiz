# frozen_string_literal: true

module GithubToCanvasQuiz
  module MarkdownParser
    class Question < Base
      attr_accessor :course_id, :quiz_id, :id, :type, :name, :description, :comment, :answers, :distractors

      def parse
        read_frontmatter!
        scan_heading!

        self.answers ||= []
        self.distractors ||= []
        scan_answers!

        to_h
      end

      def to_h
        {
          course_id: course_id,
          quiz_id: quiz_id,
          id: id,
          type: type,
          name: name,
          description: description,
          comment: comment,
          answers: answers,
          distractors: distractors
        }
      end

      private

      def read_frontmatter!
        frontmatter.each do |key, value|
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end

      def scan_heading!
        # Name - contents of first H1
        question_heading = scanner.scan_until('h1').last
        self.name = question_heading.content

        # Description/Comments - contents between H1 and first H2
        question_body_nodes = scanner.scan_before('h2')
        description_nodes, comment_nodes = parse_block_body(question_body_nodes)
        self.description = description_nodes.to_html.strip
        self.comment = comment_nodes ? comment_nodes.first.inner_html.strip : ''
      end

      def scan_answers!
        while scanner.check('h2')
          answer_heading = scanner.scan('h2')
          answer_title = answer_heading.content
          answer_body_nodes = scanner.scan_before('h2') || scanner.scan_rest
          if type == 'matching_question' && answer_title == 'Incorrect'
            self.distractors = parse_distractors(answer_body_nodes)
          else
            self.answers << parse_answer(answer_body_nodes, answer_title, type)
          end
        end
      end

      def parse_distractors(nodes)
        extract_text_from(nodes, 'li')
      end

      def parse_answer(nodes, title, type)
        answer_nodes, comment_nodes = parse_block_body(nodes)
        comment = comment_nodes ? comment_nodes.first.inner_html.strip : ''
        case type
        when 'matching_question'
          left, right = extract_text_from(answer_nodes, 'li')
          { type: type, title: title, left: left, right: right, text: left, comments: comment }
        when 'fill_in_multiple_blanks_question'
          text, blank_id = extract_text_from(answer_nodes, 'li')
          { type: type, title: title, text: text, comments: comment, blank_id: blank_id }
        when 'true_false_question', 'short_answer_question'
          text = extract_text_from(answer_nodes, 'p').first
          { type: type, title: title, text: text, comments: comment }
        else
          { type: type, title: title, text: answer_nodes.to_html.strip, comments: comment }
        end
      end

      def parse_block_body(nodes)
        scanner = HTML::Scanner.new(nodes)
        content = scanner.scan_before('blockquote') || scanner.scan_rest
        comment = scanner.scan_rest unless scanner.eof?
        [content, comment]
      end

      def extract_text_from(nodes, selector)
        nodes.css(selector).map do |node|
          CGI.unescapeHTML(node.content).strip
        end
      end
    end
  end
end
