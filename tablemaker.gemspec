# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tablemaker/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Levin Alexander"]
  gem.email         = ["mail@levinalex.net"]
  gem.description   = "HTML table generator that allows arbitrary nested cell subdivisions and applies colspan/rowspan as needed."

  gem.summary       = ""
  gem.homepage      = "https://github.com/levinalex/tablemaker"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "tablemaker"
  gem.require_paths = ["lib"]
  gem.version       = Tablemaker::VERSION

  gem.add_dependency "rake"
  gem.add_development_dependency "minitest"
end
