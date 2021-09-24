# frozen_string_literal: true

# API
require 'rest-client'
require 'json'
require_relative 'github_to_canvas_quiz/canvas_api/endpoints'
require_relative 'github_to_canvas_quiz/canvas_api/client'

# CLI
require 'thor'
require_relative 'github_to_canvas_quiz/cli'

# Renderer Helpers
require 'yaml'
require 'reverse_markdown'
require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'
require_relative 'github_to_canvas_quiz/reverse_markdown/converters/pre'
require_relative 'github_to_canvas_quiz/markdown_builder'
require_relative 'github_to_canvas_quiz/markdown_converter'

# Parsers/Canvas
require_relative 'github_to_canvas_quiz/parser/canvas/answer'
require_relative 'github_to_canvas_quiz/parser/canvas/base'
require_relative 'github_to_canvas_quiz/parser/canvas/question'
require_relative 'github_to_canvas_quiz/parser/canvas/quiz'

# Parsers/Markdown
require 'front_matter_parser'
require 'nokogiri'
require_relative 'github_to_canvas_quiz/parser/markdown/helpers/node_parser'
require_relative 'github_to_canvas_quiz/parser/markdown/helpers/node_scanner'
require_relative 'github_to_canvas_quiz/parser/markdown/answer'
require_relative 'github_to_canvas_quiz/parser/markdown/base'
require_relative 'github_to_canvas_quiz/parser/markdown/question'
require_relative 'github_to_canvas_quiz/parser/markdown/quiz'

# Models
require_relative 'github_to_canvas_quiz/model/answer/fill_in_multiple_blanks'
require_relative 'github_to_canvas_quiz/model/answer/matching'
require_relative 'github_to_canvas_quiz/model/answer/multiple_answers'
require_relative 'github_to_canvas_quiz/model/answer/multiple_choice'
require_relative 'github_to_canvas_quiz/model/answer/short_answer'
require_relative 'github_to_canvas_quiz/model/answer/true_false'
require_relative 'github_to_canvas_quiz/model/quiz'
require_relative 'github_to_canvas_quiz/model/question'

# Synchronizer
require_relative 'github_to_canvas_quiz/synchronizer/quiz'

# Builder
require_relative 'github_to_canvas_quiz/builder/quiz'

require_relative 'github_to_canvas_quiz/version'

module GithubToCanvasQuiz
  class UnknownQuestionType < StandardError; end

  class FileNotFoundError < StandardError; end

  class DirectoryNotFoundError < StandardError; end

  class Error < StandardError; end
end
