module RDF::JSON
  ##
  # RDF/JSON parser.
  #
  # @example Reading RDF/JSON data
  #   RDF::JSON::Reader.open("spec/data/test.json") do |reader|
  #     reader.each_statement do |statement|
  #       puts statement.inspect
  #     end
  #   end
  #
  # @see http://n2.talis.com/wiki/RDF_JSON_Specification
  class Reader < RDF::Reader
    format RDF::JSON::Format

    # TODO
  end
end
