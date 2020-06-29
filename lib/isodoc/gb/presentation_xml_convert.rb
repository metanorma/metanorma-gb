require_relative "init"
require "isodoc"

module IsoDoc
  module Gb
    class PresentationXMLConvert < IsoDoc::Iso::PresentationXMLConvert
      def example1(f)
        n = @xrefs.get[f["id"]]
        lbl = (n.nil? || n[:label].nil? || n[:label].empty?) ? @example_lbl :
          l10n("#{@example_lbl} #{n[:label]}")
        prefix_name(f, "&nbsp;&mdash; ", l10n(lbl + ":"))
      end

      include Init
    end
  end
end

