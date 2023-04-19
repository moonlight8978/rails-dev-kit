
require 'rails'
require "debug"
require 'rspec/matchers/fail_matchers'
require 'rspec/collection_matchers'

require_relative "./test_helper"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.warnings = true
  config.include RSpec::Matchers::FailMatchers
end
