# frozen_string_literal: true

require "metanorma/standoc"
module Metanorma
  module Gb
  end
end

module Metanorma
  module Gb::Document
  end
end

module Metanorma
  existing = defined?(Metanorma::GbDocument) && Metanorma::GbDocument
  if !existing.equal?(Metanorma::Gb::Document)
    Metanorma.send(:remove_const, :GbDocument) if existing
    GbDocument = Metanorma::Gb::Document
  end
end

# OCP adoption: ONE registration in the metanorma-core flavor table
require "metanorma-core"

Metanorma::Core::Flavors.register(Metanorma::Core::Flavor.new(
  name: :gb,
  gem: "metanorma-gb",
  model_root: Metanorma::Gb::Document::Root,
  pubid_module: nil,
  renderers: { html: Metanorma::Html::StandardRenderer },
))
