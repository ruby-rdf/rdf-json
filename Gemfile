source "https://rubygems.org"

gemspec

gem "rdf",              github: "ruby-rdf/rdf", :branch => "develop"

group :development do
  gem 'rdf-isomorphic', github: "ruby-rdf/rdf-isomorphic",  branch: "develop"
  gem "rdf-spec",       github: "ruby-rdf/rdf-spec", :branch => "develop"
end

group :debug do
  gem "redcarpet",  platforms: :ruby
  gem "byebug",     platforms: :mri
  gem "ruby-debug", platforms: :jruby
end

group :test do
  gem 'simplecov', '~> 0.21',  platforms: :mri
  gem 'simplecov-lcov', '~> 0.8',  platforms: :mri
  gem 'coveralls',  platforms: :mri
end
