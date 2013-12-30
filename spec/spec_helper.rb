require "bundler/setup"
require 'rspec'
require 'matchers'
require 'rdf/json'
require 'rdf/spec'
require 'rdf/isomorphic'

RSpec.configure do |config|
  config.include(RDF::Spec::Matchers)
  config.exclusion_filter = {:ruby => lambda { |version|
    RUBY_VERSION.to_s !~ /^#{version}/
  }}
end
