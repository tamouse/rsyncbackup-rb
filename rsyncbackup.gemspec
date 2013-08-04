lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rsyncbackup/version'

Gem::Specification.new do |gem|
  gem.name          = "rsyncbackup"
  gem.version       = Rsyncbackup::VERSION
  gem.authors       = ["Tamara Temple"]
  gem.email         = ["tamouse@gmail.com"]
  gem.description   = %q{Yet another rsyncbackup script, this time in ruby}
  gem.summary       = %q{Yet another rsyncbackup script, this time in ruby}
  gem.homepage      = "http://github.com/tamouse/rsyncbackup-rb"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency('rdoc')
  gem.add_development_dependency('aruba')
  gem.add_development_dependency('rake')
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('guard')
  gem.add_development_dependency('guard-rspec')
  gem.add_development_dependency('guard-cucumber')
  
  gem.add_dependency('methadone')

end
