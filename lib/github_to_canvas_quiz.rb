# frozen_string_literal: true

# HTML scanning
require 'nokogiri'
require_relative 'github_to_canvas_quiz/html/scanner'

# API
require 'rest-client'
require 'json'
require_relative 'github_to_canvas_quiz/canvas_api/endpoints'
require_relative 'github_to_canvas_quiz/canvas_api/client'

# CLI
require 'thor'
require_relative 'github_to_canvas_quiz/cli'

# Markdown to HTML
require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'
require_relative 'github_to_canvas_quiz/markdown_converter'

# Parsers
require 'front_matter_parser'
require_relative 'github_to_canvas_quiz/markdown_parser/base'
require_relative 'github_to_canvas_quiz/markdown_parser/question'
require_relative 'github_to_canvas_quiz/markdown_parser/quiz'

# Converters
require 'yaml'
require 'reverse_markdown'
require_relative 'github_to_canvas_quiz/reverse_markdown/converters/pre'
require_relative 'github_to_canvas_quiz/converter/helpers/markdown'
require_relative 'github_to_canvas_quiz/converter/answer/fill_in_multiple_blanks'
require_relative 'github_to_canvas_quiz/converter/answer/matching'
require_relative 'github_to_canvas_quiz/converter/answer/multiple_answers'
require_relative 'github_to_canvas_quiz/converter/answer/multiple_choice'
require_relative 'github_to_canvas_quiz/converter/answer/short_answer'
require_relative 'github_to_canvas_quiz/converter/answer/true_false'
require_relative 'github_to_canvas_quiz/converter/quiz'
require_relative 'github_to_canvas_quiz/converter/question'

# Synchronizer
require_relative 'github_to_canvas_quiz/synchronizer/repo'
require_relative 'github_to_canvas_quiz/synchronizer/question'
require_relative 'github_to_canvas_quiz/synchronizer/quiz'

# Repository
require_relative 'github_to_canvas_quiz/repo_builder'

require_relative 'github_to_canvas_quiz/version'

module GithubToCanvasQuiz
  class UnknownQuestionType < StandardError; end

  class FileNotFoundError < StandardError; end

  class DirectoryNotFoundError < StandardError; end

  class Error < StandardError; end
end
