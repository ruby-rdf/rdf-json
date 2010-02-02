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
  # * {RDF::JSON::Format}
  # * {RDF::JSON::Reader}
  # * {RDF::JSON::Writer}
  #
  # @example Requiring the `RDF::JSON` module
  #   require 'rdf/json'
  #
  # @see http://rdf.rubyforge.org/
  # @see http://n2.talis.com/wiki/RDF_JSON_Specification
  # @see http://en.wikipedia.org/wiki/JSON
  #
  # @author [Arto Bendiken](http://ar.to/)
  module JSON
    require 'rdf/json/format'
    autoload :Reader,  'rdf/json/reader'
    autoload :Writer,  'rdf/json/writer'
    autoload :VERSION, 'rdf/json/version'
  end
end
