# frozen_string_literal: true

# Self-contained: avoids pulling in the gem's full spec_helper (which
# may load unrelated code with pre-existing pubid-* dependency issues).
require "bundler/setup"
require "metanorma/gb/document"

RSpec.describe "Metanorma::Gb::Document namespace" do
  describe "canonical namespace" do
    it "exposes Metanorma::Gb::Document as a Module" do
      expect(Metanorma::Gb::Document).to be_a(Module)
    end

    it "exposes Root with the canonical name" do
      expect(Metanorma::Gb::Document::Root.name)
        .to eq("Metanorma::Gb::Document::Root")
    end

    it "Root is a lutaml Serializable" do
      expect(Metanorma::Gb::Document::Root < Lutaml::Model::Serializable).to be(true)
    end
  end

  describe "backwards-compat alias" do
    it "Metanorma::GbDocument aliases to the new namespace" do
      expect(Metanorma::GbDocument).to eq(Metanorma::Gb::Document)
    end

    it "the alias preserves class identity" do
      expect(Metanorma::GbDocument::Root.equal?(
               Metanorma::Gb::Document::Root)).to be(true)
    end
  end

  describe "parent namespace" do
    it "Metanorma::Standoc::Document is available" do
      expect(Metanorma::Standoc::Document).to be_a(Module)
    end

    it "Metanorma::StandardDocument alias is available" do
      expect(Metanorma::StandardDocument).to eq(Metanorma::Standoc::Document)
    end
  end
end
