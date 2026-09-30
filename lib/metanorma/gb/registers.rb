# frozen_string_literal: true

require "lutaml/model"

module Metanorma
  module Gb
    # The gb lutaml-model register: creates the :gb_document context
    # with the standoc document register as fallback. Mirrors the
    # metanorma-jis register pattern.
    module Registers
      def self.setup
        reg = Lutaml::Model::Register.new(:gb_document,
                                          fallback: [:standoc_document])
        Lutaml::Model::GlobalRegister.register(reg)
      end
    end
  end
end
