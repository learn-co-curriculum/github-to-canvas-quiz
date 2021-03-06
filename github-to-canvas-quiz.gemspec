# frozen_string_literal: true

require_relative 'lib/github_to_canvas_quiz/version'

Gem::Specification.new do |spec|
  spec.name          = 'github-to-canvas-quiz'
  spec.version       = GithubToCanvasQuiz::VERSION
  spec.authors       = ['ihollander']
  spec.email         = ['ianholla@gmail.com']

  spec.summary       = 'Synchronize Canvas quiz content with GitHub'
  spec.homepage      = 'https://github.com/learn-co-curriculum/github-to-canvas-quiz'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.5.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(/\A(?:(?:test|spec|features)\/|\.(?:git|travis|circleci)|appveyor)/)
    end
  end
  spec.bindir        = 'bin'
  spec.executables   = 'github-to-canvas-quiz'
  spec.require_paths = ['lib']

  spec.add_dependency 'front_matter_parser', '~> 1.0'
  spec.add_dependency 'git', '~> 1.9'
  spec.add_dependency 'htmlentities', '~> 4.3'
  spec.add_dependency 'nokogiri', '~> 1.12'
  spec.add_dependency 'redcarpet', '~> 3.5'
  spec.add_dependency 'rest-client', '~> 2.1'
  spec.add_dependency 'reverse_markdown', '~> 2.0'
  spec.add_dependency 'rouge', '~> 3.26'
  spec.add_dependency 'thor', '~> 1.1.0'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
