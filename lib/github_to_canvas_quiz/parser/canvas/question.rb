# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Canvas
      class Question < Base
        attr_accessor :course_id, :quiz_id, :id, :type, :sources, :name, :description, :answers, :distractors

        # Parse the frontmatter/HTML from the Markdown document and return a hash of parsed data
        def get_from_api(course_id, quiz_id)
          quiz_data = client.get_single_quiz(options[:course], options[:quiz])
          new(
            course_id: course_id,
            quiz_id: quiz_id,
            id: data['id'],
            type: data['question_type'],
            name: data['question_name'] || '',
            description: data['question_text'] || '',
            sources: parse_sources(data['neutral_comments_html']),
            answers: data['answers'].map do |answer|
              answer_from_canvas(data['question_type'], answer)
            end,
            distractors: (data['matching_answer_incorrect_matches'] || '').split("\n")
          )

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
      end
    end
  end
end
