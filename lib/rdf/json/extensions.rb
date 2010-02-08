module RDF::JSON
  ##
  # RDF/JSON extensions for [RDF.rb](http://rdf.rubyforge.org/) core classes
  # and mixins.
  #
  # Classes are extended with two new instance methods:
  #
  # * `#to_rdf_json` returns the RDF/JSON representation as a `Hash` object.
  # * `#to_json` returns the serialized RDF/JSON representation as a string.
  #
  # @example Serializing blank nodes into RDF/JSON format
  #   RDF::Node.new(id).to_json
  #
  # @example Serializing URI references into RDF/JSON format
  #   RDF::URI.new("http://rdf.rubyforge.org/").to_json
  #
  # @example Serializing plain literals into RDF/JSON format
  #   RDF::Literal.new("Hello, world!").to_json
  #
  # @example Serializing language-tagged literals into RDF/JSON format
  #   RDF::Literal.new("Hello, world!", :language => 'en-US').to_json
  #
  # @example Serializing datatyped literals into RDF/JSON format
  #   RDF::Literal.new(3.1415).to_json
  #   RDF::Literal.new('true', :datatype => RDF::XSD.boolean).to_json
  #
  # @example Serializing statements into RDF/JSON format
  #   RDF::Statement.new(s, p, o).to_json
  #
  # @example Serializing enumerables into RDF/JSON format
  #   [RDF::Statement.new(s, p, o)].extend(RDF::Enumerable).to_json
  #
  module Extensions
    ##
    # RDF/JSON extensions for `RDF::Value`.
    module Value
      ##
      # Returns the serialized RDF/JSON representation of this value.
      #
      # @return [String]
      def to_json
        # Any RDF/JSON-compatible class must implement `#to_rdf_json`:
        to_rdf_json.to_json
      end
    end

    ##
    # RDF/JSON extensions for `RDF::Node`.
    module Node
      ##
      # Returns the RDF/JSON representation of this blank node.
      #
      # @return [Hash]
      def to_rdf_json
        {:type => :bnode, :value => to_s}
      end
    end

    ##
    # RDF/JSON extensions for `RDF::URI`.
    module URI
      ##
      # Returns the RDF/JSON representation of this URI reference.
      #
      # @return [Hash]
      def to_rdf_json
        {:type => :uri, :value => to_s}
      end
    end

    ##
    # RDF/JSON extensions for `RDF::Literal`.
    module Literal
      ##
      # Returns the RDF/JSON representation of this literal.
      #
      # @return [Hash]
      def to_rdf_json
        case
          when datatype? # FIXME: use `has_datatype?` in RDF.rb 0.1.0
            {:type => :literal, :value => value.to_s, :datatype => datatype.to_s}
          when language? # FIXME: use `has_language?` in RDF.rb 0.1.0
            {:type => :literal, :value => value.to_s, :lang => language.to_s}
          else
            {:type => :literal, :value => value.to_s}
        end
      end
    end

    ##
    # RDF/JSON extensions for `RDF::Statement`.
    module Statement
      ##
      # Returns the RDF/JSON representation of this statement.
      #
      # @return [Hash]
      def to_rdf_json
        # FIXME: improve the RDF::Statement constructor in RDF.rb 0.1.0
        s, p, o = subject.to_s, predicate.to_s, object.is_a?(RDF::Value) ? object : RDF::Literal.new(object)
        {s => {p => [o.to_rdf_json]}}
      end
    end

    ##
    # RDF/JSON extensions for `RDF::Enumerable`.
    module Enumerable
      ##
      # Returns the serialized RDF/JSON representation of this object.
      #
      # @return [String]
      def to_json
        to_rdf_json.to_json
      end

      ##
      # Returns the RDF/JSON representation of this object.
      #
      # @return [Hash]
      def to_rdf_json
        json = {}
        each_statement do |statement|
          s = statement.subject.to_s
          p = statement.predicate.to_s
          o = statement.object.is_a?(RDF::Value) ? statement.object : RDF::Literal.new(statement.object)
          json[s]    ||= {}
          json[s][p] ||= []
          json[s][p] << o.to_rdf_json
        end
        json
      end
    end

    ##
    # RDF/JSON extensions for `RDF::Repository`.
    module Repository
      include Enumerable
    end
  end # module Extensions

  Extensions.constants.each do |klass|
    RDF.const_get(klass).send(:include, Extensions.const_get(klass))
  end
end # module RDF::JSON
