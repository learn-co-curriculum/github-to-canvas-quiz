# frozen_string_literal: true

module GithubToCanvasQuiz
  module MarkdownParser
    class Question
      attr_reader :markdown

      def initialize(markdown)
        @markdown = markdown
      end

      def parse
        frontmatter, html = separate_frontmatter_and_html
        src = StringScanner.new(html)

        # Must call these in order, relies on moving the StringScanner position
        name = parse_name!(src)
        description = parse_description!(src)
        comment = parse_comment!(src)
        answers = parse_answers!(src)
        distractors = ''

        distractors, answers = separate_matching_answers(answers) if frontmatter['type'] == 'matching_question'

        {
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

      def separate_frontmatter_and_html
        parsed = FrontMatterParser::Parser.new(:md).call(markdown)
        html = MarkdownConverter.new(parsed.content).to_html
        [parsed.front_matter, html]
      end

      def parse_name!(src)
        src.scan(/<h1>(.*?)<\/h1>/)
        src.captures[0]
      end

      def parse_description!(src)
        # Check if there is a Blockquote before the next H2
        if /<blockquote>/ =~ src.check_until(/(.*?)<h2>/m)
          # Scan until the next blockquote
          src.scan_until(/(?=<blockquote>)/).strip
        elsif src.check_until(/(?=<h2>)/)
          # Scan until the next H2
          src.scan_until(/(?=<h2>)/).strip
        else
          # Read until end
          src.rest.strip
        end
      end

      def parse_comment!(src)
        return unless /<blockquote>/ =~ src.check_until(/(.*?)<h2>/m)

        blockquote = (src.scan_until(/(?=<h2>)/) || '').strip
        /<blockquote>(.*)<\/blockquote>/m.match(blockquote).captures[0].strip
      end

      def parse_answers!(src)
        answers = []
        # Get answers from all H2s with "Correct" or "Incorrect"
        while src.scan(/<h2>(Correct|Incorrect)<\/h2>/) || src.eos?
          answer = {}
          answer['title'] = src.captures[0]

          answer['html'] = parse_description!(src)
          answer['comments_html'] = parse_comment!(src) || ''

          answer['weight'] = answer['title'] == 'Incorrect' ? 0 : 100

          answers << answer
        end
        answers
      end

      def separate_matching_answers(answers)
        # Pull out distractors
        incorrect = answers.find { |answer| answer['title'] == 'Incorrect' }
        distractors = incorrect['html'].scan(/<li>(?<text>.*)<\/li>/).flatten

        # Pull out other answers
        correct_answers = answers.filter { |answer| answer != incorrect }
        matching_answers = correct_answers.map do |answer|
          left, right = answer['html'].scan(/<li>(?<text>.*)<\/li>/).flatten
          {
            'text' => left,
            'left' => left,
            'right' => right,
            'comments_html' => answer['comments_html'],
            'title' => answer['title']
          }
        end
        [distractors, matching_answers]
      end
    end
  end
end
