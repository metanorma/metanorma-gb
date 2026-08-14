# frozen_string_literal: true

require "metanorma/standoc"
module Metanorma
  module Gb::Document
    class Root < Lutaml::Model::Serializable
      include Metanorma::Standoc::Document::RootAttributes

      def self.lutaml_default_register
        :gb_document
      end

      attribute :bibdata, Metadata::GbBibliographicItem
      attribute :preface,
                Metanorma::IsoDocument::Sections::IsoPreface
      attribute :sections,
                Metanorma::IsoDocument::Sections::IsoSections
      attribute :annex,
                Metanorma::IsoDocument::Sections::IsoAnnexSection,
                collection: true

      xml do
        element "metanorma"
        namespace Metanorma::Standoc::Document::Namespace

        Metanorma::Standoc::Document::RootXmlMapping.apply(self)
      end
    end
  end
end
