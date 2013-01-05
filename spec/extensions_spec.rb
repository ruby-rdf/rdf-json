require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::JSON::Extensions do
  context "blank nodes" do
    it "should have an RDF/JSON representation" do
      value = RDF::Node.new('id')
      value.should respond_to(:to_rdf_json)
      value.to_rdf_json.should be_a(Hash)
      value.to_rdf_json.should == {:type => :bnode, :value => '_:id'}
    end
  end

  context "URI references" do
    it "should have an RDF/JSON representation" do
      value = RDF::URI('http://rdf.rubyforge.org/')
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
      value.to_json.should == value.to_rdf.to_json
    end
  end

  context "statements" do
    it "should have an RDF/JSON representation" do
      statement = RDF::Statement.new(RDF::URI('http://rdf.rubyforge.org/'), RDF::DC.title, 'RDF.rb')
      statement.should respond_to(:to_json, :to_rdf_json)
      statement.to_rdf_json.should be_a(Hash)
      statement.to_rdf_json.should == {'http://rdf.rubyforge.org/' => {RDF::DC.title.to_s => [{:type => :literal, :value => 'RDF.rb'}]}}
    end
  end

  context "enumerables" do
    it "should have an RDF/JSON representation" do
      statement  = RDF::Statement.new(RDF::URI('http://rdf.rubyforge.org/'), RDF::DC.title, 'RDF.rb')
      enumerable = [statement].extend(RDF::Enumerable)
      enumerable.should respond_to(:to_json, :to_rdf_json)
      enumerable.to_rdf_json.should be_a(Hash)
    end
  end

  context "graphs" do
    it "should have an RDF/JSON representation" do
      statement  = RDF::Statement.new(RDF::URI('http://rdf.rubyforge.org/'), RDF::DC.title, 'RDF.rb')
      graph      = RDF::Graph.new { |g| g << statement }
      graph.should respond_to(:to_json, :to_rdf_json)
      graph.to_rdf_json.should be_a(Hash)
      graph.to_rdf_json.should == statement.to_rdf_json
    end
  end

  context "repositories" do
    it "should have an RDF/JSON representation" do
      statement  = RDF::Statement.new(RDF::URI('http://rdf.rubyforge.org/'), RDF::DC.title, 'RDF.rb')
      repository = RDF::Repository.new
      repository << statement
      repository.should respond_to(:to_json, :to_rdf_json)
      repository.to_rdf_json.should be_a(Hash)
      repository.to_rdf_json.should == statement.to_rdf_json
    end
  end
end
