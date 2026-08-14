# frozen_string_literal: true

require "metanorma/standoc"
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
