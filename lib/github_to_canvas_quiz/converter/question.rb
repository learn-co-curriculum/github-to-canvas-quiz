# frozen_string_literal: true

module GithubToCanvasQuiz
  module Converter
    class Question
      class << self
        def from_markdown(markdown)
          options = MarkdownParser::Question.new(markdown).parse
          options[:answers] = options[:answers].map do |answer|
            answer_from(options[:type], answer)
          end
          new(options)
        end

        def from_canvas(course_id, quiz_id, data)
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
        end

        private

        def parse_sources(html)
          return unless html

          Nokogiri::HTML5.fragment(html).css('a').map do |node|
            name = node.content.gsub('Links to an external site.', '')
            { 'name' => name, 'url' => node['href'] }
          end
        end

        def answer_from(type, answer_data)
          case type
          when 'fill_in_multiple_blanks_question' then Answer::FillInMultipleBlanks.new(answer_data)
          when 'matching_question' then Answer::Matching.new(answer_data)
          when 'multiple_answers_question' then Answer::MultipleAnswers.new(answer_data)
          when 'multiple_choice_question' then Answer::MultipleChoice.new(answer_data)
          when 'short_answer_question' then Answer::ShortAnswer.new(answer_data)
          when 'true_false_question' then Answer::TrueFalse.new(answer_data)
          else
            raise UnknownQuestionType(type)
          end
        end

        def answer_from_canvas(type, answer_data)
          case type
          when 'fill_in_multiple_blanks_question' then Answer::FillInMultipleBlanks.from_canvas(answer_data)
          when 'matching_question' then Answer::Matching.from_canvas(answer_data)
          when 'multiple_answers_question' then Answer::MultipleAnswers.from_canvas(answer_data)
          when 'multiple_choice_question' then Answer::MultipleChoice.from_canvas(answer_data)
          when 'short_answer_question' then Answer::ShortAnswer.from_canvas(answer_data)
          when 'true_false_question' then Answer::TrueFalse.from_canvas(answer_data)
          else
            raise UnknownQuestionType(type)
          end
        end
      end

      include Helpers::Markdown

      attr_accessor :course_id, :quiz_id, :id, :type, :sources, :name, :description, :answers, :distractors

      def initialize(options)
        options.each do |key, value|
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end

      def to_markdown
        blocks = []
        blocks << frontmatter(frontmatter_hash)
        blocks << h1(name)
        blocks << markdown_block(description)
        blocks.concat(answers.map(&:to_markdown))
        unless distractors.empty?
          blocks << h2('Incorrect')
          blocks << ul(*distractors)
        end
        join(blocks)
      end

      def to_h
        {
          'question_name' => name,
          'question_text' => description,
          'question_type' => type,
          'points_possible' => 1,
          'neutral_comments_html' => sources ? sources_to_html : '',
          'answers' => answers.map(&:to_h),
          'matching_answer_incorrect_matches' => distractors.join("\n")
        }
      end

      private

      def frontmatter_hash
        {
          'course_id' => course_id,
          'quiz_id' => quiz_id,
          'id' => id,
          'type' => type,
          'sources' => sources
        }
      end

      def sources_to_html
        comments = sources.map do |source|
          "<a href=\"#{source['url']}\">#{source['name']}</a>"
        end.join('')
        
        "<p><strong>Source/s:</strong> #{comments}</p>"
      end
    end
  end
end
