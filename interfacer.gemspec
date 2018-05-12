
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "interfacer/version"

Gem::Specification.new do |spec|
  spec.name          = "interfacer"
  spec.version       = Interfacer::VERSION
  spec.authors       = ["Chris D'Aloisio"]
  spec.email         = ["chris@creativecontrol.com.au"]

  spec.summary       = "Declaratively define your interfaces and their implementations"
  spec.description   = "Writing too many specs? Can't decide on a common structure for all of your excellent OOP? This gem is biased, but can help."
  spec.homepage      = "https://chrisdaloisio.com/interfacer"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
