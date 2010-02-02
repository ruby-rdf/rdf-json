module RDF::JSON
  ##
  # RDF/JSON serializer.
  #
  # @example Obtaining an RDF/JSON writer class
  #   RDF::Writer.for(:json)         #=> RDF::JSON::Writer
  #   RDF::Writer.for("spec/data/test.json")
  #   RDF::Writer.for(:file_name      => "spec/data/test.json")
  #   RDF::Writer.for(:file_extension => "json")
  #   RDF::Writer.for(:content_type   => "application/json")
  #
  # @example Serializing RDF statements into an RDF/JSON file
  #   RDF::JSON::Writer.open("spec/data/test.json") do |writer|
  #     graph.each_statement do |statement|
  #       writer << statement
  #     end
  #   end
  #
  # @example Serializing RDF statements into an RDF/JSON string
  #   RDF::JSON::Writer.buffer do |writer|
  #     graph.each_statement do |statement|
  #       writer << statement
  #     end
  #   end
  #
  # @see http://n2.talis.com/wiki/RDF_JSON_Specification
  class Writer < RDF::Writer
    format RDF::JSON::Format

    # TODO
  end
end
