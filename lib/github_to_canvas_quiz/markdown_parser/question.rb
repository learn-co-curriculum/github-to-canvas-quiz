# frozen_string_literal: true

module GithubToCanvasQuiz
  module MarkdownParser
    class Question < Base
      def parse
        # Must call these in order, relies on moving the StringScanner position
        name = parse_name!
        description = parse_description!
        comment = parse_comment!
        answers, distractors = parse_answers!(frontmatter['type'])

        {
          course_id: frontmatter['course_id'],
          quiz_id: frontmatter['quiz_id'],
          id: frontmatter['id'],
          type: frontmatter['type'],
          name: name,
          description: description,
          comment: comment,
          answers: answers,
          distractors: distractors
        }
      end

      private

      def parse_name!
        src.scan(/<h1>(.*?)<\/h1>/)
        src.captures.first
      end

      def parse_description!
        if /<blockquote>/ =~ src.check_until(/(?=<h2>)/)
          # If there is a <blockquote> before the next <h2>, scan until the next <blockquote>
          src.scan_until(/(?=<blockquote>)/).strip
        elsif src.check_until(/(?=<(h2|blockquote)>)/)
          # If there is a <h2> or  <blockquote> before the end, scan until the next <h2> or  <blockquote>
          src.scan_until(/(?=<(h2|blockquote)>)/).strip
        else
          # No more <h2>s or <blockquote>s, so the rest of the string is the description
          src.rest.strip
        end
      end

      def parse_comment!
        if /<blockquote>/ =~ src.check_until(/(?=<h2>)/)
          # If there is a <blockquote> before the next <h2>, scan until the next <h2>
          html = src.scan_until(/(?=<h2>)/).strip
          read_blockquote(html)
        elsif src.match?(/<blockquote>/)
          # If there is a <blockquote> before the next <h2>, and we landed on a <blockquote>
          # (should only happen in the last section)
          read_blockquote(src.rest)
        else
          ''
        end
      end

      def parse_answers!(type)
        answers = []
        distractors = []
        # Get answers from all H2s with "Correct" or "Incorrect"
        while src.scan(/<h2>(Correct|Incorrect)<\/h2>/)
          if type == 'matching_question' && src.captures.first == 'Incorrect'
            html = parse_description!
            distractors = read_list_items(html)
          else
            answers << parse_answer!(type)
          end
        end
        [answers, distractors]
      end

      def parse_answer!(type)
        # Must call these in order, relies on moving the StringScanner position
        title = src.captures.first
        description = parse_description!
        comments = parse_comment!
        case type
        when 'matching_question'
          left, right = read_list_items(description)
          answer_hash(title: title, left: left, right: right, text: left, comments: comments)
        when 'true_false_question'
          answer_hash(title: title, text: read_paragraph(description), comments: comments)
        else
          answer_hash(title: title, text: description, comments: comments)
        end
      end

      def read_list_items(html)
        html.scan(/<li>(?<text>.*)<\/li>/).flatten.map(&:strip)
      end

      def read_blockquote(html)
        /<blockquote>(.*)<\/blockquote>/m.match(html).captures.first.strip
      end

      def read_paragraph(html)
        /<p>(.*)<\/p>/m.match(html).captures.first.strip
      end

      def answer_hash(title:, text:, comments:, left: '', right: '')
        {
          title: title,
          left: left,
          right: right,
          text: text,
          comments: comments
        }
      end
    end
  end
end
