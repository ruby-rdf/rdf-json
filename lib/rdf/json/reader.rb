module RDF::JSON
  ##
  # RDF/JSON parser.
  #
  # @example Obtaining an RDF/JSON reader class
  #   RDF::Reader.for(:json)         #=> RDF::JSON::Reader
  #   RDF::Reader.for("etc/doap.json")
  #   RDF::Reader.for(:file_name      => "etc/doap.json")
  #   RDF::Reader.for(:file_extension => "json")
  #   RDF::Reader.for(:content_type   => "application/json")
  #
  # @example Parsing RDF statements from an RDF/JSON file
  #   RDF::JSON::Reader.open("etc/doap.json") do |reader|
  #     reader.each_statement do |statement|
  #       puts statement.inspect
  #     end
  #   end
  #
  # @example Parsing RDF statements from an RDF/JSON string
  #   data = StringIO.new(File.read("etc/doap.json"))
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

        JSON.parse(@input.read).each do |subject, predicates|
          subject = parse_subject(subject)
          predicates.each do |predicate, objects|
            predicate = parse_predicate(predicate)
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
    # Parses an RDF/JSON subject string into a URI reference or blank node.
    #
    # @param  [String] subject
    # @return [RDF::Resource]
    def parse_subject(subject)
      case subject
        when /^_:/ then RDF::Node.new(subject[2..-1])
        else RDF::URI.new(subject)
      end
    end

    ##
    # Parses an RDF/JSON predicate string into a URI reference.
    #
    # @param  [String] predicate
    # @return [RDF::URI]
    def parse_predicate(predicate)
      # TODO: optional support for CURIE predicates (issue #1 on GitHub).
      RDF::URI.intern(predicate)
    end

    ##
    # Parses an RDF/JSON object string into an RDF value.
    #
    # @param  [Hash{String => Object}] object
    # @return [RDF::Value]
    def parse_object(object)
      raise RDF::ReaderError.new, "missing 'type' key in #{object.inspect}"  unless object.has_key?('type')
      raise RDF::ReaderError.new, "missing 'value' key in #{object.inspect}" unless object.has_key?('value')

      case type = object['type']
        when 'bnode'
          RDF::Node.new(object['value'][2..-1])
        when 'uri'
          RDF::URI.new(object['value'])
        when 'literal'
          RDF::Literal.new(object['value'], {
            :language => object['lang'],
            :datatype => object['datatype'],
          })
        else
          raise RDF::ReaderError, "expected 'type' to be 'bnode', 'uri', or 'literal', but got #{type.inspect}"
      end
    end

    ##
    # @private
    # @see   RDF::Reader#each_graph
    # @since 0.2.0
    def each_graph(&block)
      block_given? ? @block.call(@graph) : enum_for(:each_graph).extend(RDF::Countable)
    end

    ##
    # @private
    # @see   RDF::Reader#each_statement
    def each_statement(&block)
      block_given? ? @graph.each_statement(&block) : enum_for(:each_statement).extend(RDF::Countable)
    end

    ##
    # @private
    # @see   RDF::Reader#each_statement
    def each_triple(&block)
      block_given? ? @graph.each_triple(&block) : enum_for(:each_triple).extend(RDF::Countable)
    end
  end # class Reader
end # module RDF::JSON
