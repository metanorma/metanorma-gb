# frozen_string_literal: true

require "metanorma/standoc"
require "metanorma/iso/document/models"
module Metanorma
  module Gb
  end
end

module Metanorma
  module Gb::Document
    autoload :Metadata, "metanorma/gb/document/metadata"
    autoload :Root, "metanorma/gb/document/root"
  end
end

module Metanorma
  existing = defined?(Metanorma::GbDocument) && Metanorma::GbDocument
  if !existing.equal?(Metanorma::Gb::Document)
    Metanorma.send(:remove_const, :GbDocument) if existing
    GbDocument = Metanorma::Gb::Document
  end
end

require "metanorma/gb/registers"
Metanorma::Gb::Registers.setup

# OCP adoption: ONE registration in the metanorma-core flavor table
require "metanorma-core"

Metanorma::Core::Flavors.register(Metanorma::Core::Flavor.new(
  name: :gb,
  gem: "metanorma-gb",
  model_root: Metanorma::Gb::Document::Root,
  pubid_module: nil,
  renderers: { html: lambda do |_document, **_options|
    Metanorma::Html::StandardRenderer
  end },
))
