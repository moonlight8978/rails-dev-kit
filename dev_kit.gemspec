# frozen_string_literal: true

require_relative "lib/dev_kit/version"

Gem::Specification.new do |spec|
  spec.name        = "dev_kit"
  spec.version     = DevKit::VERSION
  spec.authors     = ["moonlight8978"]
  spec.email       = ["moonlight8978@gmail.com"]
  spec.homepage    = "https://github.com/aoe-brotherhood/ruby-dev-kit"
  spec.summary     = "Ruby on Rails Development Kit"
  spec.description = "Ruby on Rails Development Kit"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/aoe-brotherhood/ruby-dev-kit"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.test_files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["spec/**/*"]
  end

  spec.add_dependency "rails", ">= 7.0.4.2"
  spec.add_dependency "enumerize"
  spec.add_dependency "dry-validation"
  spec.add_dependency "dry-schema"
  spec.add_dependency "dry-logic"
  spec.add_development_dependency "eth"
  spec.add_development_dependency "jwt"

  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "rspec-collection_matchers"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "debug"
end
