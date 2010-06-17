require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::JSON::Format do
  it "should be discoverable" do
    formats = [
      RDF::Format.for(:json),
      RDF::Format.for("etc/doap.json"),
      RDF::Format.for(:file_name      => "etc/doap.json"),
      RDF::Format.for(:file_extension => "json"),
      RDF::Format.for(:content_type   => "application/json"),
    ]
    formats.each { |format| format.should == RDF::JSON::Format }
  end
end
