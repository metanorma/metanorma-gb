require "spec_helper"

RSpec.describe Asciidoctor::Gb do
  it "has a version number" do
    expect(Asciidoctor::Gb::VERSION).not_to be nil
  end

  it "generates output for the Rice document" do
    system "cd spec/examples; rm -f rice.doc; rm -f rice.html; asciidoctor --trace -b gb -r 'asciidoctor-gb' rice.adoc; cd ../.."
    expect(File.exist?("spec/examples/rice.doc")).to be true
    expect(File.exist?("spec/examples/rice.html")).to be true
  end

end
