# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "rbstream"
  spec.version = "0.1.0"
  spec.authors = ["ricksterhd123"]
  spec.email = ["ricksterhd123@gmail.com"]

  spec.summary = "A proof of concept icecast2 source client in ruby"
  spec.description = "A proof of concept icecast2 source client in ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.2"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end

  spec.bindir = "bin"
  spec.executables = ["rbstream"]
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
