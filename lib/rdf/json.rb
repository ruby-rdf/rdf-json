require 'rdf'

module RDF
  ##
  # RDF/JSON plugin for RDF.rb.
  #
  # @see http://n2.talis.com/wiki/RDF_JSON_Specification
  # @see http://www.json.org/
  # @see http://en.wikipedia.org/wiki/JSON
  module JSON
    autoload :Format,  'rdf/json/format'
    autoload :Reader,  'rdf/json/reader'
    autoload :Writer,  'rdf/json/writer'
    autoload :VERSION, 'rdf/json/version'
  end
end
