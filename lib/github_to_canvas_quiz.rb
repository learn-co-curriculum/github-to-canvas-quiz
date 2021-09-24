# frozen_string_literal: true

require 'front_matter_parser'
require 'json'
require 'nokogiri'
require 'redcarpet'
require 'rest-client'
require 'reverse_markdown'
require 'rouge'
require 'rouge/plugins/redcarpet'
require 'thor'
require 'yaml'

require 'github_to_canvas_quiz/builder/quiz'

require 'github_to_canvas_quiz/canvas_api/endpoints/quizzes'
require 'github_to_canvas_quiz/canvas_api/endpoints/quiz_questions'
require 'github_to_canvas_quiz/canvas_api/endpoints'
require 'github_to_canvas_quiz/canvas_api/client'

require 'github_to_canvas_quiz/model/answer/fill_in_multiple_blanks'
require 'github_to_canvas_quiz/model/answer/matching'
require 'github_to_canvas_quiz/model/answer/multiple_answers'
require 'github_to_canvas_quiz/model/answer/multiple_choice'
require 'github_to_canvas_quiz/model/answer/short_answer'
require 'github_to_canvas_quiz/model/answer/true_false'
require 'github_to_canvas_quiz/model/quiz'
require 'github_to_canvas_quiz/model/question'

require 'github_to_canvas_quiz/parser/canvas/answer'
require 'github_to_canvas_quiz/parser/canvas/base'
require 'github_to_canvas_quiz/parser/canvas/question'
require 'github_to_canvas_quiz/parser/canvas/quiz'
require 'github_to_canvas_quiz/parser/markdown/helpers/node_parser'
require 'github_to_canvas_quiz/parser/markdown/helpers/node_scanner'
require 'github_to_canvas_quiz/parser/markdown/answer'
require 'github_to_canvas_quiz/parser/markdown/base'
require 'github_to_canvas_quiz/parser/markdown/question'
require 'github_to_canvas_quiz/parser/markdown/quiz'

require 'github_to_canvas_quiz/reverse_markdown/converters/pre'

require 'github_to_canvas_quiz/synchronizer/quiz'

require 'github_to_canvas_quiz/cli'
require 'github_to_canvas_quiz/markdown_builder'
require 'github_to_canvas_quiz/markdown_converter'
require 'github_to_canvas_quiz/version'

module GithubToCanvasQuiz
  class UnknownQuestionType < StandardError; end

  class FileNotFoundError < StandardError; end

  class DirectoryNotFoundError < StandardError; end

  class Error < StandardError; end
end
