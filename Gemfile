source "https://rubygems.org"

gemspec

gem "rdf",      :git => "git://github.com/ruby-rdf/rdf.git", :branch => "develop"

group :development do
  gem 'rdf-isomorphic', git: "git://github.com/ruby-rdf/rdf-isomorphic.git",  branch: "develop"
  gem "rdf-spec", :git => "git://github.com/ruby-rdf/rdf-spec.git", :branch => "develop"
end

group :debug do
  gem "wirble"
  gem "redcarpet", :platforms => :ruby
  gem "debugger", :platform => :mri_19
  gem "byebug", :platforms => [:mri_20, :mri_21]
  gem "ruby-debug", :platforms => :jruby
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'rubinius', '~> 2.0'
  gem 'json'
end
