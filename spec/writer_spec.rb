require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/writer'

describe RDF::JSON::Writer do
  it_behaves_like 'an RDF::Writer' do
    let(:writer) {RDF::JSON::Writer.new}
  end

  it "should be discoverable" do
    writers = [
      RDF::Writer.for(:rj),
      RDF::Writer.for("etc/test.rj"),
      RDF::Writer.for(file_name:      "etc/test.rj"),
      RDF::Writer.for(file_extension: "rj"),
      RDF::Writer.for(content_type:   "application/rdf+json"),
    ]
    writers.each { |writer| expect(writer).to eq RDF::JSON::Writer }
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
      it "serializes #{test}" do
        g = RDF::Graph.new << RDF::NTriples::Reader.new(nt)
        str = g.dump(:rj)
        expect(JSON.parse(str)).to eq(JSON.parse(json))
      end
    end
  end
end
