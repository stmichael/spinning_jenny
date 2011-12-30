# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "spinning_jenny/version"

Gem::Specification.new do |s|
  s.name        = "spinning_jenny"
  s.version     = SpinningJenny::VERSION
  s.authors     = ["Michael Stämpfli"]
  s.email       = ["michael.staempfli@garaio.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "spinning_jenny"

  s.add_development_dependency 'rspec'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
