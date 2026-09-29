# frozen_string_literal: true

require "metanorma/standoc"
module Metanorma
  module Gb::Document
    class Root < Lutaml::Model::Serializable
      include Metanorma::Standoc::Document::RootAttributes

      # The GB model chain is the ISO one (RootXmlMapping, ISO section
      # classes), so parse context resolves through the ISO register.
      def self.lutaml_default_register
        :iso_document
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
