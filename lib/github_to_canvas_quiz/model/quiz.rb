# frozen_string_literal: true

module GithubToCanvasQuiz
  module Model
    class Quiz
      attr_accessor :course_id, :id, :repo, :title, :description

      def initialize(options)
        options.each do |key, value|
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end

      def to_markdown
        MarkdownBuilder.build do |md|
          md.frontmatter(frontmatter_hash)
          md.h1(title)
          md.md(md.html_to_markdown(description))
        end
      end

      def to_h
        {
          'title' => title,
          'description' => description_with_header,
          'quiz_type' => 'assignment',
          'shuffle_answers' => true,
          'hide_results' => nil,
          'show_correct_answers_last_attempt' => true,
          'allowed_attempts' => 3,
          'scoring_policy' => 'keep_highest',
          'one_question_at_a_time' => true
        }
      end

      def frontmatter_hash
        {
          'id' => id,
          'course_id' => course_id,
          'repo' => repo
        }
      end

      private

      def description_with_header
        [git_links_header, description].reject(&:nil?).join("\n")
      end

      def git_links_header
        return unless repo

        <<~HTML
          <div id='git-data-element' data-org='learn-co-curriculum' data-repo='#{repo}'></div>
          <header class='fis-header'>
            <a class='fis-git-link' href='https://github.com/learn-co-curriculum/#{repo}/issues/new' target='_blank' rel='noopener'><img id='issue-img' title='Create New Issue' alt='Create New Issue' /></a>
          </header>
        HTML
      end
    end
  end
end
