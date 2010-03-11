require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::JSON::Extensions do
  context "blank nodes" do
    it "should have an RDF/JSON representation" do
      value = RDF::Node.new('id')
      value.should respond_to(:to_json, :to_rdf_json)
      value.to_rdf_json.should be_a(Hash)
      value.to_rdf_json.should == {:type => :bnode, :value => '_:id'}
    end
  end

  context "URI references" do
    it "should have an RDF/JSON representation" do
      value = RDF::URI.new('http://rdf.rubyforge.org/')
      value.should respond_to(:to_json, :to_rdf_json)
      value.to_rdf_json.should be_a(Hash)
      value.to_rdf_json.should == {:type => :uri, :value => 'http://rdf.rubyforge.org/'}
    end
  end

  context "plain literals" do
    it "should have an RDF/JSON representation" do
      value = RDF::Literal.new('Hello, world!')
      value.should respond_to(:to_json, :to_rdf_json)
      value.to_rdf_json.should be_a(Hash)
      value.to_rdf_json.should == {:type => :literal, :value => 'Hello, world!'}
    end
  end

  context "language-tagged literals" do
    it "should have an RDF/JSON representation" do
      value = RDF::Literal.new('Hello, world!', :language => 'en-US')
      value.should respond_to(:to_json, :to_rdf_json)
      value.to_rdf_json.should be_a(Hash)
      value.to_rdf_json.should == {:type => :literal, :value => 'Hello, world!', :lang => 'en-US'}
    end
  end

  context "datatyped literals" do
    it "should have an RDF/JSON representation" do
      value = RDF::Literal.new(true)
      value.should respond_to(:to_json, :to_rdf_json)
      value.to_rdf_json.should be_a(Hash)
      value.to_rdf_json.should == {:type => :literal, :value => 'true', :datatype => RDF::XSD.boolean.to_s}
    end
  end

  context "statements" do
    it "should have an RDF/JSON representation" do
      statement = RDF::Statement.new(RDF::URI.new('http://rdf.rubyforge.org/'), RDF::DC.title, 'RDF.rb')
      statement.should respond_to(:to_json, :to_rdf_json)
      statement.to_rdf_json.should be_a(Hash)
      statement.to_rdf_json.should == {'http://rdf.rubyforge.org/' => {RDF::DC.title.to_s => [{:type => :literal, :value => 'RDF.rb'}]}}
    end
  end

  context "enumerables" do
    it "should have an RDF/JSON representation" do
      statement  = RDF::Statement.new(RDF::URI.new('http://rdf.rubyforge.org/'), RDF::DC.title, 'RDF.rb')
      enumerable = [statement].extend(RDF::Enumerable)
      enumerable.should respond_to(:to_json, :to_rdf_json)
      enumerable.to_rdf_json.should be_a(Hash)
      enumerable.to_rdf_json.should == statement.to_rdf_json
      enumerable.to_json.should == statement.to_json
    end
  end

  context "repositories" do
    it "should have an RDF/JSON representation" do
      statement  = RDF::Statement.new(RDF::URI.new('http://rdf.rubyforge.org/'), RDF::DC.title, 'RDF.rb')
      repository = RDF::Repository.new
      repository << statement
      repository.should respond_to(:to_json, :to_rdf_json)
      repository.to_rdf_json.should be_a(Hash)
      repository.to_rdf_json.should == statement.to_rdf_json
      repository.to_json.should == statement.to_json
    end
  end
end

describe RDF::JSON::Reader do
  context "when parsing subjects and predicates" do
    before :each do
      @reader = RDF::JSON::Reader.new('{}')
    end

    it "should parse blank nodes" do
      bnode = @reader.parse_subject(input = '_:foobar')
      bnode.should be_a_node
      bnode.id.should == 'foobar'
      bnode.to_s.should == input
    end

    it "should parse URIs" do
      uri = @reader.parse_subject(input = 'http://rdf.rubyforge.org/')
      uri.should be_a_uri
      uri.to_s.should == input
    end
  end

  context "when parsing objects" do
    before :each do
      @reader = RDF::JSON::Reader.new('{}')
    end

    it "should parse blank nodes" do
      bnode = @reader.parse_object(input = {'type' => 'bnode', 'value' => '_:foobar'})
      bnode.should be_a_node
      bnode.id.should == 'foobar'
      bnode.to_s.should == input['value']
    end

    it "should parse URIs" do
      uri = @reader.parse_object(input = {'type' => 'uri', 'value' => 'http://rdf.rubyforge.org/'})
      uri.should be_a_uri
      uri.to_s.should == input['value']
    end

    it "should parse plain literals" do
      literal = @reader.parse_object(input = {'type' => 'literal', 'value' => 'Hello!'})
      literal.should be_a_literal
      literal.should be_plain
      literal.value.should == input['value']
    end

    it "should parse language-tagged literals" do
      literal = @reader.parse_object(input = {'type' => 'literal', 'value' => 'Hello!', 'lang' => 'en'})
      literal.should be_a_literal
      literal.should have_language
      literal.value.should == input['value']
      literal.language.should == input['lang'].to_sym
    end

    it "should parse datatyped literals" do
      literal = @reader.parse_object(input = {'type' => 'literal', 'value' => '3.1415', 'datatype' => RDF::XSD.double.to_s})
      literal.should be_a_literal
      literal.should have_datatype
      literal.value.should == input['value']
      literal.datatype.should == RDF::URI.new(input['datatype'])
    end
  end

  context "when parsing etc/doap.json" do
    before :each do
      etc = File.expand_path(File.join(File.dirname(__FILE__), '..', 'etc'))
      @ntriples = RDF::NTriples::Reader.new(File.open(File.join(etc, 'doap.nt')))
      @reader = RDF::JSON::Reader.open(File.join(etc, 'doap.json'))
    end

    it "should return the correct number of statements" do
      @reader.graph.count.should == @ntriples.count
    end
  end
end

describe RDF::JSON::Writer do
  # TODO
end
