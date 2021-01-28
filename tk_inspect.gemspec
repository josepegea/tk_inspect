
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tk_inspect/version"

Gem::Specification.new do |spec|
  spec.name          = "tk_inspect"
  spec.version       = TkInspect::VERSION
  spec.authors       = ["Josep Egea"]
  spec.email         = ["jes@josepegea.com"]

  spec.summary       = %q{Poor's man Smalltalk-like environment for Ruby using TK}
  spec.description   = %q{Poor's man Smalltalk-like environment for Ruby using TK}
  spec.homepage      = "https://github.com/josepegea/tk_inspect"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/josepegea/tk_inspect"
    spec.metadata["changelog_uri"] = "https://github.com/josepegea/tk_inspect"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "tk_component", "~> 0.1.2"

  spec.add_dependency "rouge", "~> 3.26"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
