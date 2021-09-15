# frozen_string_literal: true

module GithubToCanvasQuiz
  module Converter
    class Question
      class << self
        def from_markdown(markdown)
          options = MarkdownParser::Question.new(markdown).parse
          options[:answers] = options[:answers].map do |answer|
            Answer.new(answer)
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
            comment: data['neutral_comments_html'] || '',
            answers: data['answers'].map { |answer| Answer.from_canvas(answer) },
            distractors: (data['matching_answer_incorrect_matches'] || '').split("\n")
          )
        end
      end

      include Helpers::Markdown

      attr_accessor :course_id, :quiz_id, :id, :type, :name, :description, :comment, :answers, :distractors

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
        blocks << blockquote(comment) unless comment.empty?
        answers.each do |answer|
          blocks << answer.to_markdown
        end
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
          'neutral_comments_html' => comment,
          'answers' => answers.map { |answer| answer.to_h(type) },
          'matching_answer_incorrect_matches' => distractors.join("\n")
        }
      end

      private

      def frontmatter_hash
        {
          'course_id' => course_id,
          'quiz_id' => quiz_id,
          'id' => id,
          'type' => type
        }
      end
    end
  end
end
