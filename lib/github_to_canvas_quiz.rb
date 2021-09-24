# frozen_string_literal: true

# API
require 'rest-client'
require 'json'
require_relative 'github_to_canvas_quiz/canvas_api/endpoints'
require_relative 'github_to_canvas_quiz/canvas_api/client'

# CLI
require 'thor'
require_relative 'github_to_canvas_quiz/cli'

# Parsers/Canvas
require_relative 'github_to_canvas_quiz/parser/canvas/answer'
require_relative 'github_to_canvas_quiz/parser/canvas/base'
require_relative 'github_to_canvas_quiz/parser/canvas/question'
require_relative 'github_to_canvas_quiz/parser/canvas/quiz'

# Parsers/Markdown
require 'front_matter_parser'
require 'nokogiri'
require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'
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

# Converters
# require_relative 'github_to_canvas_quiz/converter/answer/fill_in_multiple_blanks'
# require_relative 'github_to_canvas_quiz/converter/answer/matching'
# require_relative 'github_to_canvas_quiz/converter/answer/multiple_answers'
# require_relative 'github_to_canvas_quiz/converter/answer/multiple_choice'
# require_relative 'github_to_canvas_quiz/converter/answer/short_answer'
# require_relative 'github_to_canvas_quiz/converter/answer/true_false'
# require_relative 'github_to_canvas_quiz/converter/quiz'
# require_relative 'github_to_canvas_quiz/converter/question'

# Synchronizer
require_relative 'github_to_canvas_quiz/synchronizer/repo'
require_relative 'github_to_canvas_quiz/synchronizer/question'
require_relative 'github_to_canvas_quiz/synchronizer/quiz'

# Repository
require_relative 'github_to_canvas_quiz/repo_builder'

require_relative 'github_to_canvas_quiz/version'

# Renderers
require 'yaml'
require 'reverse_markdown'
require_relative 'github_to_canvas_quiz/reverse_markdown/converters/pre'
require_relative 'github_to_canvas_quiz/markdown_builder'

module GithubToCanvasQuiz
  class UnknownQuestionType < StandardError; end

  class FileNotFoundError < StandardError; end

  class DirectoryNotFoundError < StandardError; end

  class Error < StandardError; end
end
