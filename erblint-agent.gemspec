# frozen_string_literal: true

require_relative "lib/erblint/agent/version"

Gem::Specification.new do |spec|
  spec.name = "erblint-agent"
  spec.version = Erblint::Agent::VERSION
  spec.authors = ["aki77"]
  spec.email = ["aki77@users.noreply.github.com"]

  spec.summary = "Template style checking for Ruby projects aimed at AI agents"
  spec.description = "A collection of ERB template linters designed for AI agent Ruby projects, enforcing consistent style and best practices including SVG tag restrictions, emoji usage controls, and class naming conventions"
  spec.homepage = "https://github.com/aki77/erblint-agent"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/aki77/erblint-agent"
  spec.metadata["changelog_uri"] = "https://github.com/aki77/erblint-agent/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "better_html", ">= 2.0"
  spec.add_runtime_dependency "erb_lint", ">= 0.3.0"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
