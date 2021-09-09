# frozen_string_literal: true

require_relative "lib/quince/version"

Gem::Specification.new do |spec|
  spec.name          = "quince"
  spec.version       = Quince::VERSION
  spec.authors       = ["Joseph Johansen"]
  spec.email         = ["joe@stotles.com"]

  spec.summary       = "The ruby framework for building dynamic & stateful user experiences"
  spec.description   = "Quince is an opinionated framework for building dynamic yet fully server-rendered web apps, with little to no JavaScript"
  spec.homepage      = "https://github.com/johansenja/quince"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "typed_struct", ">= 0.1.4"
  spec.add_dependency "oj", "~> 3.13"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
