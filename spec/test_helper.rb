# frozen_string_literal: true

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../spec/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../spec/dummy/db/migrate", __dir__)]
require "rails/test_help"

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end