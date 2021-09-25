# frozen_string_literal: true

module GithubToCanvasQuiz
  module Parser
    module Canvas
      module Helpers
        def choose_text(text, html)
          html.empty? ? text : clean_html(html)
        end

        def clean_html(html)
          html = remove_canvas_cruft(html)
          HTMLEntities.new.decode(html)
        end

        def remove_canvas_cruft(html)
          nodes = Nokogiri::HTML5.fragment(html)
          nodes.css('.screenreader-only').remove
          cleaned_html = nodes.to_html
          cleaned_html.gsub(/\(?Links to an external site.\)?/, '')
        end
      end
    end
  end
end
