# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Canvas
      # Parses a quiz from the Canvas API and returns a Quiz
      class Quiz
        include Helpers

        attr_reader :data

        def initialize(data)
          @data = data
        end

        def parse
          Model::Quiz.new(
            course_id: data['course_id'],
            id: data['id'],
            repo: repo,
            title: data['title'],
            description: description
          )
        end

        private

        # Remove header elements
        def description
          nodes = Nokogiri::HTML5.fragment(data['description'])
          nodes.css('#git-data-element').remove
          nodes.css('.fis-header').remove
          nodes.to_html.strip
        end

        # Parse the repo from the #git-data-element
        def repo
          data_element = Nokogiri::HTML5.fragment(data['description']).css('#git-data-element').first
          data_element ? data_element['data-repo'] : nil
        end
      end
    end
  end
end
