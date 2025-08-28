# frozen_string_literal: true

require "erb_lint"
require "erb_lint/file_loader"
require "erb_lint/linter_config"
require "erb_lint/linter"
require "erb_lint/offense"
require "erb_lint/processed_source"
require "better_html"
require "better_html/parser"
require "erblint/agent"
require "erblint/agent/linters"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
