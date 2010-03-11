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

    ##
    # @return [RDF::Graph]
    attr_reader :graph

    ##
    # Initializes the RDF/JSON reader instance.
    #
    # @param  [IO, File, String]       input
    # @param  [Hash{Symbol => Object}] options
    # @yield  [reader]
    # @yieldparam [Reader] reader
    def initialize(input = $stdin, options = {}, &block)
      super do
        @graph = RDF::Graph.new

        JSON.parse(input.read).each do |subject, predicates|
          subject = parse_resource(subject)
          predicates.each do |predicate, objects|
            predicate = parse_resource(predicate)
            objects.each do |object|
              object = parse_object(object)
              @graph << [subject, predicate, object]
            end
          end
        end

        block.call(self) if block_given?
      end
    end

    ##
    # Parses an RDF/JSON resource string into a URI or blank node.
    #
    # @param  [String] resource
    # @return [RDF::Resource]
    def parse_resource(resource)
      case resource
        when /^_:/ then RDF::Node.new(resource[2..-1])
        else RDF::URI.new(resource)
      end
    end

    ##
    # Parses an RDF/JSON object string into an RDF value.
    #
    # @param  [Hash{String => Object}] object
    # @return [RDF::Value]
    def parse_object(object)
      case type = object['type'].to_sym
        when :bnode
          RDF::Node.new(object['value'][2..-1])
        when :uri
          RDF::URI.new(object['value'])
        when :literal
          RDF::Literal.new(object['value'], {
            :language => object['lang'],
            :datatype => object['datatype'],
          })
        else
          raise RDF::ReaderError, "expected :bnode, :uri, or :literal, got #{type.inspect}"
      end
    end

    ##
    # Iterates the given block for each RDF statement in the input.
    #
    # @yield  [statement]
    # @yieldparam [RDF::Statement] statement
    # @return [void]
    def each_statement(&block)
      @graph.each_statement(&block)
    end

    ##
    # Iterates the given block for each RDF triple in the input.
    #
    # @yield  [subject, predicate, object]
    # @yieldparam [RDF::Resource] subject
    # @yieldparam [RDF::URI]      predicate
    # @yieldparam [RDF::Value]    object
    # @return [void]
    def each_triple(&block)
      @graph.each_triple(&block)
    end
  end # class Reader
end # module RDF::JSON
