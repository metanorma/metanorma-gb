# frozen_string_literal: true

require "metanorma/standoc"
iso_document_models = begin
  require "metanorma/iso/document"
  true
rescue LoadError
  false
end
# Compile-only bundles resolve the released metanorma-iso line, which
# predates the ISO document models the flavor table needs; rendering
# bundles pin the model-layout iso and register below.
return unless iso_document_models

# Forward-declare parent namespace so this file is safe to require
# directly (without first requiring metanorma/gb.rb).
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


# Backwards-compat alias so external consumers that reference
# Metanorma::GbDocument keep resolving during the transition.
module Metanorma
  existing = defined?(Metanorma::GbDocument) && Metanorma::GbDocument
  if !existing.equal?(Metanorma::Gb::Document)
    Metanorma.send(:remove_const, :GbDocument) if existing
    GbDocument = Metanorma::Gb::Document
  end
end

if defined?(Metanorma::Registers::Setup.setup_gb_register)
  Metanorma::Registers::Setup.setup_gb_register
end

module Metanorma
  deprecate_constant :GbDocument
end

require "metanorma-core"

# OCP adoption: ONE registration in the metanorma-core flavor table
# (metanorma-core#18). Lazy: the table exists only on the flavor-table
# line of metanorma-core; skip silently on resolutions without it.
if defined?(Metanorma::Core::Flavors)
  Metanorma::Core::Flavors.register(Metanorma::Core::Flavor.new(
                                      name: :gb,
                                      gem: "metanorma-gb",
                                      model_root: Metanorma::Gb::Document::Root,
                                      pubid_module: nil,
                                      renderers: { html: lambda do |_document, **_options|
                                        require "metanorma/gb/html"
                                        Metanorma::Gb::Html::Renderer
                                      end },
                                    ))
end
