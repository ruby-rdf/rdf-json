#!/usr/bin/env ruby
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'lib')))
require 'rubygems'
begin
  require 'rakefile' # @see http://github.com/bendiken/rakefile
rescue LoadError => e
end

require 'rdf/json'

namespace :gem do
  desc "Build the rdf-json-#{File.read('VERSION').chomp}.gem file"
  task :build do
    sh "gem build rdf-json.gemspec && mv rdf-json-#{File.read('VERSION').chomp}.gem pkg/"
  end

  desc "Release the rdf-json-#{File.read('VERSION').chomp}.gem file"
  task :release do
    sh "gem push pkg/rdf-json-#{File.read('VERSION').chomp}.gem"
  end
end

desc "Generate etc/doap.{nt,rj} from etc/doap.ttl."
task :doap do
  require 'rdf/json'
  require 'rdf/turtle'
  require 'rdf/ntriples'
  g = RDF::Graph.load("etc/doap.ttl")
  RDF::NTriples::Writer.open("etc/doap.nt") {|w| w <<g }
  RDF::JSON::Writer.open("etc/doap.rj") {|w| w <<g }
end
