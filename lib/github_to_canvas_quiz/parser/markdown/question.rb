# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Markdown
      class Question < Base
        # Parse the frontmatter/HTML from the Markdown document and return a Question and its associated Answers
        def parse
          Model::Question.new(
            course_id: frontmatter['course_id'],
            quiz_id: frontmatter['quiz_id'],
            id: frontmatter['id'],
            type: frontmatter['type'],
            sources: frontmatter['sources'],
            name: name,
            description: description,
            answers: answers,
            distractors: distractors
          )
        end

        private

        # Name - contents of first H1
        def name
          scanner = Helpers::NodeScanner.from_html(html)
          scanner.scan_until('h1').last.content
        end

        # Description - contents between H1 and first H2
        def description
          scanner = Helpers::NodeScanner.from_html(html)
          scanner.scan_until('h1')
          scanner.scan_before('h2').to_html.strip
        end

        # Each H2 and the content before the next H2 represent an answer
        def answers
          scanner = Helpers::NodeScanner.from_html(html)
          scanner.scan_before('h2')
          answers = []
          while scanner.check('h2')
            title = scanner.scan('h2').content
            unless frontmatter['type'] == 'matching_question' && title == 'Incorrect'
              nodes = scanner.scan_before('h2') || scanner.scan_rest
              answers << Parser::Markdown::Answer.for(frontmatter['type'], title, nodes)
            end
          end
          answers
        end

        # Distractors only apply to incorrect answers for the matching_question type
        def distractors
          return [] unless frontmatter['type'] == 'matching_question'

          scanner = Helpers::NodeScanner.from_html(html)
          scanner.scan_before('h2')
          while scanner.check('h2')
            return parse_text_from_nodes(answer_body_nodes, 'li') if scanner.scan('h2').content == 'Incorrect'
          end

          []
        end
      end
    end
  end
end
