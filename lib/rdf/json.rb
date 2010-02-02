require 'rdf'

module RDF
  ##
  # **`RDF::JSON`** is an RDF/JSON plugin for RDF.rb.
  #
  # Dependencies
  # ------------
  #
  # * [RDF.rb](http://gemcutter.org/gems/rdf) (>= 0.0.9)
  # * [JSON](http://gemcutter.org/gems/json_pure) (>= 1.2.0)
  #
  # Installation
  # ------------
  #
  # The recommended installation method is via RubyGems. To install the latest
  # official release from Gemcutter, do:
  #
  #     % [sudo] gem install rdf-json
  #
  # Documentation
  # -------------
  #
  # * {RDF::JSON::Extensions}
  # * {RDF::JSON::Format}
  # * {RDF::JSON::Reader}
  # * {RDF::JSON::Writer}
  #
  # @example Requiring the `RDF::JSON` module
  #   require 'rdf/json'
  #
  # @example Serializing blank nodes into RDF/JSON
  #   RDF::Node.new(id).to_json
  #
  # @example Serializing URI references into RDF/JSON
  #   RDF::URI.new("http://rdf.rubyforge.org/").to_json
  #
  # @example Serializing plain literals into RDF/JSON
  #   RDF::Literal.new("Hello, world!").to_json
  #
  # @example Serializing language-tagged literals into RDF/JSON
  #   RDF::Literal.new("Hello, world!", :language => 'en-US').to_json
  #
  # @example Serializing datatyped literals into RDF/JSON
  #   RDF::Literal.new(3.1415).to_json
  #   RDF::Literal.new('true', :datatype => RDF::XSD.boolean).to_json
  #
  # @example Serializing statements into RDF/JSON
  #   RDF::Statement.new(s, p, o).to_json
  #
  # @example Serializing enumerables into RDF/JSON
  #   [RDF::Statement.new(s, p, o)].extend(RDF::Enumerable).to_json
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
