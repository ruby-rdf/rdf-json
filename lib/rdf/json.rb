require 'rdf'

module RDF
  ##
  # **`RDF::JSON`** is an RDF/JSON plugin for RDF.rb.
  #
  # @example Requiring the `RDF::JSON` module
  #   require 'rdf/json'
  #
  # @example Serializing RDF values into RDF/JSON strings
  #   RDF::Node.new('foobar').to_json
  #   RDF::URI.new("http://rdf.rubyforge.org/").to_json
  #   RDF::Literal.new("Hello, world!").to_json
  #   RDF::Literal.new("Hello, world!", :language => 'en-US').to_json
  #   RDF::Literal.new(3.1415).to_json
  #   RDF::Literal.new('true', :datatype => RDF::XSD.boolean).to_json
  #   RDF::Statement.new(s, p, o).to_json
  #
  # @example Parsing RDF statements from an RDF/JSON file
  #   RDF::JSON::Reader.open("spec/data/test.json") do |reader|
  #     reader.each_statement do |statement|
  #       puts statement.inspect
  #     end
  #   end
  #
  # @example Serializing RDF statements into an RDF/JSON file
  #   RDF::JSON::Writer.open("spec/data/test.json") do |writer|
  #     graph.each_statement do |statement|
  #       writer << statement
  #     end
  #   end
  #
  # @see http://rdf.rubyforge.org/
  # @see http://n2.talis.com/wiki/RDF_JSON_Specification
  # @see http://en.wikipedia.org/wiki/JSON
  #
  # @author [Arto Bendiken](http://ar.to/)
  module JSON
    require 'json'
    require 'rdf/json/extensions'
    require 'rdf/json/format'
    autoload :Reader,  'rdf/json/reader'
    autoload :Writer,  'rdf/json/writer'
    autoload :VERSION, 'rdf/json/version'
  end # module JSON
end # module RDF
