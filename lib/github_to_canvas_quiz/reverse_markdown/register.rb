# frozen_string_literal: true

require_relative 'converters/p'
require_relative 'converters/pre'

module ReverseMarkdown
  Converters.register :p,   Converters::P.new
  Converters.register :pre, Converters::Pre.new
end
