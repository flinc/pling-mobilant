# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "pling-mobilant"
  s.version     = "0.1.0"
  s.authors     = ["benedikt", "t6d", "fabrik42"]
  s.email       = ["benedikt@synatic.net", "me@t6d.de", "fabrik42@gmail.com"]
  s.homepage    = "http://flinc.github.com/pling-mobilant"
  s.summary     = "Pling Gateway to Mobilant"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec", "~> 2.7"
  s.add_development_dependency "guard", "~> 0.7"
  s.add_development_dependency "guard-rspec", "~> 0.5"
  
  s.add_runtime_dependency "pling"
end
