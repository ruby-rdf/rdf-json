require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::JSON::Reader do
  it "should be discoverable" do
    readers = [
      RDF::Reader.for(:json),
      RDF::Reader.for("etc/doap.json"),
      RDF::Reader.for(:file_name      => "etc/doap.json"),
      RDF::Reader.for(:file_extension => "json"),
      RDF::Reader.for(:content_type   => "application/json"),
    ]
    readers.each { |reader| reader.should == RDF::JSON::Reader }
  end

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
