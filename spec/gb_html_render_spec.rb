# frozen_string_literal: true

# Self-contained: avoids the gem spec_helper's heavier requires.
require "bundler/setup"
require "metanorma/gb/document"
require "metanorma/gb/html"
require "metanorma/html/generator"

# The renderer registration contract: the GB root must dispatch — an
# unregistered root renders reader chrome with no document body. (No
# compiled presentation fixture exists locally; the sample corpus
# carries semantic XML only.)
RSpec.describe "Metanorma::Gb::Html::Renderer" do
  let(:xml) do
    <<~XML
      <metanorma xmlns="https://www.metanorma.org/ns/standoc" \
type="presentation" flavor="gb">
        <bibdata type="standard"><title>GB Test</title></bibdata>
        <sections><clause id="_c1" obligation="normative">
          <title>Scope</title><p id="_p1">The scope.</p>
        </clause></sections>
      </metanorma>
    XML
  end

  it "renders the GB root to a document body, not an empty shell" do
    model = Metanorma::Gb::Document::Root.from_xml(xml)
    html = Metanorma::Html::Generator.generate(model)
    page = Nokogiri::HTML(html)
    page.css("header, nav, .header-actions, button, kbd").remove

    expect(page.css("p").size).to be >= 1,
                                  "document body rendered no content (root dispatch missing)"
    expect(page.at("body").text).to include("The scope.")
  end

  it "is the renderer the flavor registry resolves" do
    entry = Metanorma::Core::Flavors.find(:gb)
    expect(entry.renderers[:html].call(nil)).to eq(Metanorma::Gb::Html::Renderer)
  end
end
