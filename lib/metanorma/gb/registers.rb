# frozen_string_literal: true

require "lutaml/model"

module Metanorma
  module Gb
    # The gb lutaml-model register: creates the :gb_document context.
    # The gb model chain is the ISO one (RootXmlMapping, ISO section
    # classes), so the fallback resolves through the ISO register,
    # matching Metanorma::Gb::Document::Root#lutaml_default_register.
    module Registers
      def self.setup
        reg = Lutaml::Model::Register.new(:gb_document,
                                          fallback: [:iso_document])
        Lutaml::Model::GlobalRegister.register(reg)
      end
    end
  end
end
