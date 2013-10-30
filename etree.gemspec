# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "etree"
  spec.version       = "0.2.0"
  spec.authors       = ["Paul Barry"]
  spec.email         = ["mail@paulbarry.com"]
  spec.summary       = %q{Scripts for converting flac files posted to http://bt.etree.org to MP3}
  spec.description   = %q{Scripts for converting flac files posted to http://bt.etree.org to MP3}
  spec.homepage      = "http://github.com/pjb3/etree"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "chronic"
  spec.add_runtime_dependency "escape"
end
