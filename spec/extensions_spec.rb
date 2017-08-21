require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::JSON::Extensions do
  context "blank nodes" do
    it "should have an RDF/JSON representation" do
      value = RDF::Node.new('id')
      expect(value).to respond_to(:to_rdf_json)
      expect(value.to_rdf_json).to be_a(Hash)
      expect(value.to_rdf_json).to eq({:type => :bnode, :value => '_:id'})
    end
  end

  context "URI references" do
    it "should have an RDF/JSON representation" do
      value = RDF::URI('https://rubygems.org/gems/rdf/')
      expect(value).to respond_to(:to_json, :to_rdf_json)
      expect(value.to_rdf_json).to be_a(Hash)
      expect(value.to_rdf_json).to eq({:type => :uri, :value => 'https://rubygems.org/gems/rdf/'})
    end
  end

  context "plain literals" do
    it "should have an RDF/JSON representation" do
      value = RDF::Literal.new('Hello, world!')
      expect(value).to respond_to(:to_json, :to_rdf_json)
      expect(value.to_rdf_json).to be_a(Hash)
      expect(value.to_rdf_json).to eq({:type => :literal, :value => 'Hello, world!'})
    end
  end

  context "language-tagged literals" do
    it "should have an RDF/JSON representation" do
      value = RDF::Literal.new('Hello, world!', :language => 'en-us')
      expect(value).to respond_to(:to_json, :to_rdf_json)
      expect(value.to_rdf_json).to be_a(Hash)
      expect(value.to_rdf_json).to eq({:type => :literal, :value => 'Hello, world!', :lang => 'en-us'})
    end
  end

  context "datatyped literals" do
    it "should have an RDF/JSON representation" do
      value = RDF::Literal.new(true)
      expect(value).to respond_to(:to_json, :to_rdf_json)
      expect(value.to_rdf_json).to be_a(Hash)
      expect(value.to_rdf_json).to eq({:type => :literal, :value => 'true', :datatype => RDF::XSD.boolean.to_s})
      expect(value.to_json).to eq value.to_rdf.to_json
    end
  end

  context "statements" do
    it "should have an RDF/JSON representation" do
      statement = RDF::Statement(RDF::URI('https://rubygems.org/gems/rdf/'), RDF::URI("http://purl.org/dc/terms/title"), 'RDF.rb')
      expect(statement).to respond_to(:to_json, :to_rdf_json)
      expect(statement.to_rdf_json).to be_a(Hash)
      expect(statement.to_rdf_json).to eq({'https://rubygems.org/gems/rdf/' => {RDF::URI("http://purl.org/dc/terms/title").to_s => [{:type => :literal, :value => 'RDF.rb'}]}})
    end
  end

  context "enumerables" do
    it "should have an RDF/JSON representation" do
      statement  = RDF::Statement(RDF::URI('https://rubygems.org/gems/rdf/'), RDF::URI("http://purl.org/dc/terms/title"), 'RDF.rb')
      enumerable = [statement].extend(RDF::Enumerable)
      expect(enumerable).to respond_to(:to_json, :to_rdf_json)
      expect(enumerable.to_rdf_json).to be_a(Hash)
    end
  end

  context "graphs" do
    it "should have an RDF/JSON representation" do
      statement  = RDF::Statement(RDF::URI('https://rubygems.org/gems/rdf/'), RDF::URI("http://purl.org/dc/terms/title"), 'RDF.rb')
      graph      = RDF::Graph.new { |g| g << statement }
      expect(graph).to respond_to(:to_json, :to_rdf_json)
      expect(graph.to_rdf_json).to be_a(Hash)
      expect(graph.to_rdf_json).to eq statement.to_rdf_json
    end
  end

  context "repositories" do
    it "should have an RDF/JSON representation" do
      statement  = RDF::Statement(RDF::URI('https://rubygems.org/gems/rdf/'), RDF::URI("http://purl.org/dc/terms/title"), 'RDF.rb')
      repository = RDF::Repository.new
      repository << statement
      expect(repository).to respond_to(:to_json, :to_rdf_json)
      expect(repository.to_rdf_json).to be_a(Hash)
      expect(repository.to_rdf_json).to eq statement.to_rdf_json
    end
  end
end
