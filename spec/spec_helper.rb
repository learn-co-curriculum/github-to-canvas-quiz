# frozen_string_literal: true

require 'dotenv'
require 'vcr'
require 'webmock/rspec'

require 'github_to_canvas_quiz'

require_relative './helpers/file_helpers'

# Override environment variables with variables in .env.test.local
Dotenv.overload('.env.test.local')

WebMock.disable_net_connect!

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
end

RSpec.configure do |config|
  # Helpers
  config.include FileHelpers

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    # This option should be set when all dependencies are being loaded
    # before a spec run, as is the case in a typical spec helper. It will
    # cause any verifying double instantiation for a class that does not
    # exist to raise, protecting against incorrectly spelt names.
    mocks.verify_doubled_constant_names = true
  end
end
