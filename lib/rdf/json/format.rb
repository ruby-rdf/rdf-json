module RDF module JSON
  ##
  # RDF/JSON format specification.
  #
  # @see http://n2.talis.com/wiki/RDF_JSON_Specification
  class Format < RDF::Format
    require 'json'

    content_type     'application/json', :extension => :json
    content_encoding 'utf-8'

    reader RDF::JSON::Reader
    writer RDF::JSON::Writer
  end
end end
