# coding: utf-8
$:.unshift "."
require 'spec_helper'
require 'rdf/spec/reader'

describe RDF::JSON::Reader do
  let!(:doap) {File.expand_path("../../etc/doap.json", __FILE__)}
  let!(:doap_nt) {File.expand_path("../../etc/doap.nt", __FILE__)}
  let!(:doap_count) {File.open(doap_nt).each_line.to_a.length}

  before(:each) do
    @reader_input = File.read(doap)
    @reader = RDF::JSON::Reader.new(@reader_input)
    @reader_count = doap_count
  end
  
  # @see lib/rdf/spec/reader.rb in rdf-spec
  include RDF_Reader

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

  context "Examples from spec" do
    {
      "example 1" => [
        %q{<http://example.org/about> <http://purl.org/dc/terms/title> "Anna's Homepage"@en .},
        %q{{
          "http://example.org/about" : {
              "http://purl.org/dc/terms/title" : [ { "value" : "Anna's Homepage", 
                                                     "type" : "literal", 
                                                     "lang" : "en" } ] 
          }
        }}
      ],
      "example 3" => [
        %q{
          <http://example.org/about> <http://purl.org/dc/terms/title> "Anna's Homepage"@en .                                                        
          <http://example.org/about> <http://purl.org/dc/terms/title> "Annas hjemmeside"@da . 
        },
        %q{{
          "http://example.org/about" : {
              "http://purl.org/dc/terms/title" : [ { "value" : "Anna's Homepage", 
                                                     "type" : "literal", 
                                                     "lang" : "en" },
                                                   { "value" : "Annas hjemmeside", 
                                                     "type" : "literal", 
                                                     "lang" : "da" } ] 
          }
        }}
      ],
      "example 5" => [
        %q{
          <http://example.org/about> <http://purl.org/dc/terms/title> "<p xmlns=\"http://www.w3.org/1999/xhtml\"><b>Anna's</b> Homepage>/p>"^^<http://www.w3.org/1999/02/22-rdf-syntax-ns#XMLLiteral> .
        },
        %q{{
          "http://example.org/about" : {
              "http://purl.org/dc/terms/title" : [ { "value" : "<p xmlns=\"http://www.w3.org/1999/xhtml\"><b>Anna's</b> Homepage>/p>", 
                                                     "type" : "literal", 
                                                     "datatype" : "http://www.w3.org/1999/02/22-rdf-syntax-ns#XMLLiteral" } ] 
          }
        }}
      ],
      "example 7" => [
        %q{
          <http://example.org/about> <http://purl.org/dc/terms/creator> _:anna .
          _:anna <http://xmlns.com/foaf/0.1/name> "Anna" . 
        },
        %q({
          "http://example.org/about" : {
              "http://purl.org/dc/terms/creator" : [ { "value" : "_:anna",   "type" : "bnode" } ]
          },
          "_:anna" : {
              "http://xmlns.com/foaf/0.1/name" : [ { "value" : "Anna",  "type" : "literal" } ] 
          }
        })
      ],
      "example 9" => [
        %q{
          _:anna <http://xmlns.com/foaf/0.1/homepage> <http://example.org/anna> .
        },
        %q{{
          "_:anna" : {
              "http://xmlns.com/foaf/0.1/homepage" : [ { "value" : "http://example.org/anna", 
                                                         "type" : "uri" } ] 
          }
        }}
      ],
      "example 11" => [
        %q{
          _:anna <http://xmlns.com/foaf/0.1/name> "Anna" .
          _:anna <http://xmlns.com/foaf/0.1/homepage> <http://example.org/anna> .        },
        %q{{
          "_:anna" : {
              "http://xmlns.com/foaf/0.1/name" : [ { "value" : "Anna", 
                                                     "type" : "literal" } ],
              "http://xmlns.com/foaf/0.1/homepage" : [ { "value" : "http://example.org/anna", 
                                                         "type" : "uri" } ] 
          }
        }}
      ],
    }.each do |test, (nt, json)|
      it "parses #{test}", :pending => (test == 'example 7') do
        g = RDF::Graph.new << RDF::JSON::Reader.new(json)
        expect(g).to be_equivalent_graph(nt)
      end
    end
  end
end
