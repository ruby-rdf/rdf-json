# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = 'rdf-json'
  gem.homepage           = 'https://github.com/ruby-rdf/rdf-json'
  gem.license            = 'Unlicense'
  gem.summary            = 'RDF/JSON support for RDF.rb.'
  gem.description        = 'RDF.rb extension for parsing/serializing RDF/JSON data.'
  gem.metadata           = {
    "documentation_uri" => "https://ruby-rdf.github.io/rdf-json",
    "bug_tracker_uri"   => "https://github.com/ruby-rdf/rdf-json/issues",
    "homepage_uri"      => "https://github.com/ruby-rdf/rdf-json",
    "mailing_list_uri"  => "https://lists.w3.org/Archives/Public/public-rdf-ruby/",
    "source_code_uri"   => "https://github.com/ruby-rdf/rdf-json",
  }

  gem.author             = 'Arto Bendiken'
  gem.email              = 'public-rdf-ruby@w3.org'

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS CREDITS README.md UNLICENSE VERSION etc/doap.rj) + Dir.glob('lib/**/*.rb')
  gem.require_paths      = %w(lib)

  gem.required_ruby_version      = '>= 2.6'
  gem.requirements               = []
  gem.add_runtime_dependency     'rdf',             '~> 3.2'
  gem.add_development_dependency 'rdf-spec',        '~> 3.2'
  gem.add_development_dependency 'rdf-isomorphic',  '~> 3.2'
  gem.add_development_dependency 'rspec',           '~> 3.10'
  gem.add_development_dependency 'rspec-its',       '~> 1.3'
  gem.add_development_dependency 'yard' ,           '~> 0.9'

  gem.post_install_message       = nil
end
