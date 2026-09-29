require_relative "init"
require "isodoc"

module IsoDoc
  module Gb
    class PresentationXMLConvert < IsoDoc::Iso::PresentationXMLConvert
      def example1(f)
        n = @xrefs.get[f["id"]]
        lbl = (n.nil? || n[:label].nil? || n[:label].empty?) ? @i18n.example :
          l10n("#{@i18n.example} #{n[:label]}")
        prefix_name(f, { caption: "&nbsp;&mdash; " }, l10n(lbl + ":"), "name")
      end

      # annex1 title prefixing is inherited: the isodoc annex1 now emits
      # the fmt-title markup itself

      include Init
    end
  end
end

