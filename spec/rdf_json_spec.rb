require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::JSON do
  # TODO
end

describe RDF::JSON::Extensions do
  context "blank nodes" do
    it "should have an RDF/JSON representation" do
      value = RDF::Node.new
      value.should respond_to(:to_json)
      value.to_json.should be_a(Hash)
    end
  end

  context "URI references" do
    it "should have an RDF/JSON representation" do
      value = RDF::URI.new("http://rdf.rubyforge.org/")
      value.should respond_to(:to_json)
      value.to_json.should be_a(Hash)
      value.to_json.should == {:type => :uri, :value => "http://rdf.rubyforge.org/"}
    end
  end

  context "plain literals" do
    it "should have an RDF/JSON representation" do
      value = RDF::Literal.new("foobar")
      value.should respond_to(:to_json)
      value.to_json.should be_a(Hash)
      value.to_json.should == {:type => :literal, :value => "foobar"}
    end
  end

  context "language-tagged literals" do
    it "should have an RDF/JSON representation" do
      value = RDF::Literal.new("foobar", :language => 'en-US')
      value.should respond_to(:to_json)
      value.to_json.should be_a(Hash)
      value.to_json.should == {:type => :literal, :value => "foobar", :lang => 'en-US'}
    end
  end

  context "datatyped literals" do
    it "should have an RDF/JSON representation" do
      value = RDF::Literal.new(true)
      value.should respond_to(:to_json)
      value.to_json.should be_a(Hash)
      value.to_json.should == {:type => :literal, :value => "true", :datatype => RDF::XSD.boolean.to_s}
    end
  end

  context "statements" do
    it "should have an RDF/JSON representation" do
      value = RDF::Statement.new(RDF::URI.new("http://rdf.rubyforge.org/"), RDF::DC.title, "RDF.rb")
      value.should respond_to(:to_json)
      value.to_json.should be_a(Hash)
      value.to_json.should == {"http://rdf.rubyforge.org/" => {RDF::DC.title.to_s => [{:type => :literal, :value => "RDF.rb"}]}}
    end
  end
end
