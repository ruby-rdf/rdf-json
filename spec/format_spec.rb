require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/format'

describe RDF::JSON::Format do
  it_behaves_like 'an RDF::Format' do
    let(:format_class) {RDF::JSON::Format}
  end

  it "should be discoverable" do
    formats = [
      RDF::Format.for(:rj),
      RDF::Format.for("etc/doap.rj"),
      RDF::Format.for(file_name:      "etc/doap.rj"),
      RDF::Format.for(file_extension: "rj"),
      RDF::Format.for(content_type:   "application/rdf+json"),
    ]
    formats.each { |format| expect(format).to eq RDF::JSON::Format }
  end
end
