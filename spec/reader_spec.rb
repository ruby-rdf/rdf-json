# coding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/reader'

describe RDF::JSON::Reader do
  let!(:doap) {File.expand_path("../../etc/doap.rj", __FILE__)}
  let!(:doap_nt) {File.expand_path("../../etc/doap.nt", __FILE__)}
  let!(:doap_count) {File.open(doap_nt).each_line.to_a.length}
  subject {RDF::JSON::Reader.new("{}")}

  before(:each) do
    @reader_input = File.read(doap)
    @reader = RDF::JSON::Reader.new(@reader_input)
    @reader_count = doap_count
  end
  
  it_behaves_like 'an RDF::Reader' do
    let(:reader_input) {File.read(doap)}
    let(:reader) {RDF::JSON::Reader.new(reader_input)}
    let(:reader_count) {doap_count}
  end

  it "should be discoverable" do
    readers = [
      RDF::Reader.for(:rj),
      RDF::Reader.for("etc/doap.rj"),
      RDF::Reader.for(file_name:      "etc/doap.rj"),
      RDF::Reader.for(file_extension: "rj"),
      RDF::Reader.for(content_type:   "application/rdf+json"),
    ]
    readers.each { |reader| expect(reader).to eq RDF::JSON::Reader }
  end

  context "when parsing subjects and predicates" do
    it "should parse blank nodes" do
      bnode = subject.parse_subject(input = '_:foobar')
      expect(bnode).to be_a_node
      expect(bnode.id).to eq 'foobar'
      expect(bnode.to_s).to eq input
    end

    it "should parse URIs" do
      uri = subject.parse_subject(input = 'https://github.com/ruby-rdf/rdf')
      expect(uri).to be_a_uri
      expect(uri.to_s).to eq input
    end
  end

  context "when parsing objects" do
    it "should parse blank nodes" do
      bnode = subject.parse_object(input = {'type' => 'bnode', 'value' => '_:foobar'})
      expect(bnode).to be_a_node
      expect(bnode.id).to eq 'foobar'
      expect(bnode.to_s).to eq input['value']
    end

    it "should parse URIs" do
      uri = subject.parse_object(input = {'type' => 'uri', 'value' => 'https://github.com/ruby-rdf/rdf'})
      expect(uri).to be_a_uri
      expect(uri.to_s).to eq input['value']
    end

    it "should parse plain literals" do
      literal = subject.parse_object(input = {'type' => 'literal', 'value' => 'Hello!'})
      expect(literal).to be_a_literal
      expect(literal).to be_plain
      expect(literal.value).to eq input['value']
    end

    it "should parse language-tagged literals" do
      literal = subject.parse_object(input = {'type' => 'literal', 'value' => 'Hello!', 'lang' => 'en'})
      expect(literal).to be_a_literal
      expect(literal).to have_language
      expect(literal.value).to eq input['value']
      expect(literal.language).to eq input['lang'].to_sym
    end

    it "should parse datatyped literals" do
      literal = subject.parse_object(input = {'type' => 'literal', 'value' => '3.1415', 'datatype' => RDF::XSD.double.to_s})
      expect(literal).to be_a_literal
      expect(literal).to have_datatype
      expect(literal.value).to eq input['value']
      expect(literal.datatype).to eq RDF::URI.new(input['datatype'])
    end
  end

  context "when parsing etc/doap.json" do
    subject {RDF::JSON::Reader.new(File.read(doap))}

    it "should return the correct number of statements" do
      expect(subject.count).to eq doap_count
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
      it "parses #{test}" do
        g = RDF::Graph.new << RDF::JSON::Reader.new(json)
        expect(g).to be_equivalent_graph(nt)
      end
    end
  end
end
