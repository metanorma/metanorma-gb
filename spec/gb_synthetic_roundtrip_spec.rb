# frozen_string_literal: true

require "bundler/setup"
require "rspec/matchers"
require "metanorma/gb/document"

RSpec.describe "GB synthetic round-trip" do
  def round_trip(root_class, xml)
    doc = root_class.from_xml(xml)
    output = doc.to_xml
    reparsed = root_class.from_xml(output)
    [doc, reparsed, output]
  end

describe "GB" do
  let(:xml) do
    <<~XML
      <metanorma type="semantic" version="1.0">
        <bibdata type="standard"><title>GB Doc</title></bibdata>
        <sections>
          <clause id="_c1"><title>Scope</title><p>Text</p></clause>
          <terms id="_t1">
            <title>Terms</title>
            <p>Boilerplate paragraph</p>
            <term id="_term1">
              <preferred><expression><name>test term</name></expression></preferred>
              <definition><p>A definition</p></definition>
            </term>
          </terms>
        </sections>
        <annex id="_a1" obligation="informative">
          <title>Annex</title><p>Annex text</p>
        </annex>
      </metanorma>
    XML
  end

  it "parses the flavor root through the ISO fallback" do
    doc = Metanorma::Gb::Document::Root.from_xml(xml)
    register = Lutaml::Model::GlobalRegister.lookup(:gb_document)
    expect(register.fallback).to include(:iso_document)
    expect(doc.sections).to be_a(Metanorma::IsoDocument::Sections::IsoSections)
    expect(doc.annex.first)
      .to be_a(Metanorma::IsoDocument::Sections::IsoAnnexSection)
    expect(doc.sections.terms.p.length).to eq(1)
    expect(doc.sections.terms.term.length).to eq(1)
  end

  it "round-trips the flavor-specific structures" do
    _, reparsed, output = round_trip(Metanorma::Gb::Document::Root, xml)
    expect(output).to include('<clause id="_c1"')
    expect(output).to include('<terms id="_t1"')
    expect(output).to include('<annex id="_a1"')
    expect(reparsed.sections.terms.term.length).to eq(1)
    expect(reparsed.annex.length).to eq(1)
  end
end
end
