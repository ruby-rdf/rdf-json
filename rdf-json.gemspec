# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = 'rdf-json'
  gem.homepage           = 'http://ruby-rdf.github.com/rdf-json'
  gem.license            = 'Unlicense'
  gem.summary            = 'RDF/JSON support for RDF.rb.'
  gem.description        = 'RDF.rb extension for parsing/serializing RDF/JSON data.'

  gem.author             = 'Arto Bendiken'
  gem.email              = 'public-rdf-ruby@w3.org'

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS CREDITS README.md UNLICENSE VERSION etc/doap.rj) + Dir.glob('lib/**/*.rb')
  gem.bindir             = %q(bin)
  gem.executables        = %w()
  gem.default_executable = gem.executables.first
  gem.require_paths      = %w(lib)
  gem.extensions         = %w()
  gem.test_files         = %w()
  gem.has_rdoc           = false

  gem.required_ruby_version      = '>= 2.2.2'
  gem.requirements               = []
  #gem.add_runtime_dependency     'rdf',             '~> 2.0'
  #gem.add_development_dependency 'rdf-spec',        '~> 2.0'
  #gem.add_development_dependency 'rdf-isomorphic',  '~> 2.0'
  gem.add_runtime_dependency     'rdf',             '>= 2.2', '< 4.0'
  gem.add_development_dependency 'rdf-spec',        '>= 2.2', '< 4.0'
  gem.add_development_dependency 'rdf-isomorphic',  '>= 2.0', '< 4.0'
  gem.add_development_dependency 'rspec',           '~> 3.4'
  gem.add_development_dependency 'rspec-its',       '~> 1.2'
  gem.add_development_dependency 'yard' ,           '~> 0.8'

  gem.post_install_message       = nil
end
