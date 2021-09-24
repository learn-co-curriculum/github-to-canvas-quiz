# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Canvas
      class Question < Base
        attr_reader :data

        # Parse the frontmatter/HTML from the Markdown document and return a hash of parsed data
        def load(course_id, quiz_id, id)
          @data = client.get_single_question(course_id, quiz_id, id)

          Model::Question.new(
            course_id: course_id,
            quiz_id: quiz_id,
            id: data['id'],
            type: data['question_type'],
            name: data['question_name'],
            description: data['question_text'],
            sources: sources,
            answers: answers,
            distractors: distractors
          )
        end

        private

        def sources
          html = data['neutral_comments_html']
          return unless html

          Nokogiri::HTML5.fragment(html).css('a').map do |node|
            name = node.content.gsub('Links to an external site.', '')
            { 'name' => name, 'url' => node['href'] }
          end
        end

        def answers
          data['answers'].map do |answer|
            Answer.for(data['question_type'], answer)
          end
        end

        def distractors
          (data['matching_answer_incorrect_matches'] || '').split("\n")
        end
      end
    end
  end
end
