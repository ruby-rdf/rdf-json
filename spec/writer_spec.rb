require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::JSON::Writer do
  it "should be discoverable" do
    writers = [
      RDF::Writer.for(:json),
      RDF::Writer.for("etc/test.json"),
      RDF::Writer.for(:file_name      => "etc/test.json"),
      RDF::Writer.for(:file_extension => "json"),
      RDF::Writer.for(:content_type   => "application/json"),
    ]
    writers.each { |writer| writer.should == RDF::JSON::Writer }
  end
end
