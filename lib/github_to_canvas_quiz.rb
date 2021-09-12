# frozen_string_literal: true

# API
require 'rest-client'
require 'json'
require_relative 'github_to_canvas_quiz/canvas_api/endpoints'
require_relative 'github_to_canvas_quiz/canvas_api/client'

# Markdown to HTML
require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'
require_relative 'github_to_canvas_quiz/markdown_converter'

# Parsers
require 'front_matter_parser'
require_relative 'github_to_canvas_quiz/markdown_parser/question'
require_relative 'github_to_canvas_quiz/markdown_parser/quiz'

# Converters
require 'yaml'
require 'reverse_markdown'
require_relative 'github_to_canvas_quiz/reverse_markdown/converters/pre'
require_relative 'github_to_canvas_quiz/converter/helpers/markdown'
require_relative 'github_to_canvas_quiz/converter/answer'
require_relative 'github_to_canvas_quiz/converter/quiz'
require_relative 'github_to_canvas_quiz/converter/question'

require_relative 'github_to_canvas_quiz/version'

module GithubToCanvasQuiz
  class Error < StandardError; end
end
