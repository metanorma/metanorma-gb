# frozen_string_literal: true

module Metanorma
  module Gb::Document
    module Metadata
      autoload :GbBibDataExtensionType,
               "#{__dir__}/metadata/gb_bib_data_extension_type"
      autoload :GbBibliographicItem,
               "#{__dir__}/metadata/gb_bibliographic_item"
    end
  end
end