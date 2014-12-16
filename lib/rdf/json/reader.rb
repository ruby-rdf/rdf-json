module RDF::JSON
  ##
  # RDF/JSON parser.
  #
  # @example Loading RDF/JSON parsing support
  #   require 'rdf/json'
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
    # The graph constructed when parsing.
    #
    # @return [RDF::Graph]
    attr_reader :graph

    ##
    # Initializes the RDF/JSON reader instance.
    #
    # @param  [IO, File, String]       input
    # @param  [Hash{Symbol => Object}] options
    #   any additional options (see `RDF::Reader#initialize`)
    # @yield  [reader] `self`
    # @yieldparam  [RDF::Reader] reader
    # @yieldreturn [void] ignored
    def initialize(input = $stdin, options = {}, &block)
      super do
        @graph = RDF::Graph.new

        @input.rewind
        ::JSON.parse(@input.read).each do |subject, predicates|
          subject = parse_subject(subject)
          predicates.each do |predicate, objects|
            predicate = parse_predicate(predicate)
            objects.each do |object|
              object = parse_object(object)
              @graph << [subject, predicate, object]
            end
          end
        end

        if block_given?
          case block.arity
            when 0 then instance_eval(&block)
            else block.call(self)
          end
        end
      end
    end

    ##
    # Parses an RDF/JSON subject string into a URI reference or blank node.
    #
    # @param  [String] subject
    # @return [RDF::Resource]
    def parse_subject(subject)
      case subject
        when /^_:/ then parse_node(subject)
        else parse_uri(subject)
      end
    end

    ##
    # Parses an RDF/JSON predicate string into a URI reference.
    #
    # @param  [String] predicate
    # @return [RDF::URI]
    def parse_predicate(predicate)
      # TODO: optional support for CURIE predicates? (issue #1 on GitHub).
      parse_uri(predicate, :intern => true)
    end

    ##
    # Parses an RDF/JSON object string into an RDF value.
    #
    # @param  [Hash{String => Object}] object
    # @return [RDF::Value]
    def parse_object(object)
      raise RDF::ReaderError, "missing 'type' key in #{object.inspect}"  unless object.has_key?('type')
      raise RDF::ReaderError, "missing 'value' key in #{object.inspect}" unless object.has_key?('value')

      case type = object['type']
        when 'bnode'
          parse_node(object['value'])
        when 'uri'
          parse_uri(object['value'])
        when 'literal'
          literal = RDF::Literal.new(object['value'], {
            :language => object['lang'],
            :datatype => object['datatype'],
          })
          literal.validate!     if validate?
          literal.canonicalize! if canonicalize?
          literal
        else
          raise RDF::ReaderError, "expected 'type' to be 'bnode', 'uri', or 'literal', but got #{type.inspect}"
      end
    end

    ##
    # Parses an RDF/JSON blank node string into an `RDF::Node` instance.
    #
    # @param  [String] string
    # @return [RDF::Node]
    # @since  0.3.0
    def parse_node(string)
      RDF::Node.new(string[2..-1]) # strips off the initial '_:'
    end
    alias_method :parse_bnode, :parse_node

    ##
    # Parses an RDF/JSON URI string into an `RDF::URI` instance.
    #
    # @param  [String] string
    # @param  [Hash{Symbol => Object}] options
    # @option options [Boolean] :intern (false)
    # @return [RDF::URI]
    # @since  0.3.0
    def parse_uri(string, options = {})
      uri = RDF::URI.send(intern = intern? && options[:intern] ? :intern : :new, string)
      uri.validate!     if validate?
      uri.canonicalize! if canonicalize? && !intern
      uri
    end

    ##
    # @private
    # @see   RDF::Reader#each_graph
    # @since 0.2.0
    def each_graph(&block)
      if block_given?
        block.call(@graph)
      end
      enum_graph
    end

    ##
    # @private
    # @see   RDF::Reader#each_statement
    def each_statement(&block)
      if block_given?
        @graph.each_statement(&block)
      end
      enum_statement
    end

    ##
    # @private
    # @see   RDF::Reader#each_triple
    def each_triple(&block)
      if block_given?
        @graph.each_triple(&block)
      end
      enum_triple
    end
  end # Reader
end # RDF::JSON
