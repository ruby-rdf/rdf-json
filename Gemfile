source "https://rubygems.org"

gemspec

gem "rdf",              github: "ruby-rdf/rdf", :branch => "develop"

group :development do
  gem 'rdf-isomorphic', github: "ruby-rdf/rdf-isomorphic",  branch: "develop"
  gem "rdf-spec",       github: "ruby-rdf/rdf-spec", :branch => "develop"
end

group :debug do
  gem "wirble"
  gem "redcarpet",  platforms: :ruby
  gem "byebug",     platforms: :mri
  gem "ruby-debug", platforms: :jruby
end

platforms :rbx do
  gem 'rubysl',   '~> 2.0'
  gem 'rubinius', '~> 2.0'
  gem 'json'
end
