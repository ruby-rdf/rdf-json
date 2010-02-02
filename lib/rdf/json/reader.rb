module RDF::JSON
  ##
  # RDF/JSON parser.
  #
  # @example Obtaining an RDF/JSON reader class
  #   RDF::Reader.for(:json)         #=> RDF::JSON::Reader
  #   RDF::Reader.for("spec/data/test.json")
  #   RDF::Reader.for(:file_name      => "spec/data/test.json")
  #   RDF::Reader.for(:file_extension => "json")
  #   RDF::Reader.for(:content_type   => "application/json") 
  #
  # @example Parsing RDF statements from an RDF/JSON file
  #   RDF::JSON::Reader.open("spec/data/test.json") do |reader|
  #     reader.each_statement do |statement|
  #       puts statement.inspect
  #     end
  #   end
  #
  # @example Parsing RDF statements from an RDF/JSON string
  #   data = StringIO.new(File.read("spec/data/test.json"))
  #   RDF::JSON::Reader.new(data) do |reader|
  #     reader.each_statement do |statement|
  #       puts statement.inspect
  #     end
  #   end
  #
  # @see http://n2.talis.com/wiki/RDF_JSON_Specification
  class Reader < RDF::Reader
    format RDF::JSON::Format

    # TODO
  end # class Reader
end # module RDF::JSON
