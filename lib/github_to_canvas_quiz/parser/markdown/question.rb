# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Markdown
      class Question < Base
        attr_accessor :course_id, :quiz_id, :id, :type, :sources, :name, :description, :answers, :distractors

        # Parse the frontmatter/HTML from the Markdown document and return a hash of parsed data
        def parse
          self.answers = []
          self.distractors = []

          read_frontmatter!
          scan_heading!
          scan_answers!

          to_h
        end

        def to_h
          # This has to produce an options hash that works with the Model::Question class...
          # probably a better way to do this...
          {
            course_id: course_id,
            quiz_id: quiz_id,
            id: id,
            type: type,
            sources: sources,
            name: name,
            description: description,
            answers: answers,
            distractors: distractors
          }
        end

        private

        # Assign each key/value pair from the parsed frontmatter to attributes of this model
        def read_frontmatter!
          frontmatter.each do |key, value|
            send("#{key}=", value) if respond_to?("#{key}=")
          end
        end

        # Scan the underlying HTML document and assign Name and Description
        def scan_heading!
          # Name - contents of first H1
          self.name = scanner.scan_until('h1').last.content
          # Description - contents between H1 and first H2
          self.description = scanner.scan_before('h2').to_html.strip
        end

        # Scan the underlying HTML document and assign Answers and Distractors
        def scan_answers!
          # Each H2 and the content before the next H2 represent an answer
          while scanner.check('h2')
            answer_title = scanner.scan('h2').content
            answer_body_nodes = scanner.scan_before('h2') || scanner.scan_rest
            if type == 'matching_question' && answer_title == 'Incorrect'
              self.distractors = parse_text_from_nodes(answer_body_nodes, 'li')
            else
              answers << parse_answer(answer_body_nodes, answer_title, type)
            end
          end
        end

        # Parse the contents of the answer nodes and return an answer hash based on the question type
        # The resulting hash must work with the Model::Answer class
        # There's probably a better way to do this too...
        def parse_answer(nodes, title, type)
          answer_nodes, comment_nodes = parse_block_body(nodes)
          comment = comment_nodes ? comment_nodes.first.inner_html.strip : ''
          case type
          when 'matching_question'
            left, right = parse_text_from_nodes(answer_nodes, 'li')
            { type: type, title: title, left: left, right: right, text: left, comments: comment }
          when 'fill_in_multiple_blanks_question'
            text, blank_id = parse_text_from_nodes(answer_nodes, 'li')
            { type: type, title: title, text: text, comments: comment, blank_id: blank_id }
          when 'true_false_question', 'short_answer_question'
            text = parse_text_from_nodes(answer_nodes, 'p').first
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
      end
    end
  end
end
