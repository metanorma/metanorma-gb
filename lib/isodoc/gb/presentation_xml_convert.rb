require_relative "init"
require "isodoc"

module IsoDoc
  module Gb
    class PresentationXMLConvert < IsoDoc::Iso::PresentationXMLConvert
      def example1(f)
        n = @xrefs.get[f["id"]]
        lbl = (n.nil? || n[:label].nil? || n[:label].empty?) ? @i18n.example :
          l10n("#{@i18n.example} #{n[:label]}")
        prefix_name(f, "&nbsp;&mdash; ", l10n(lbl + ":"), "name")
      end

      def annex1(f)
      lbl = @xrefs.anchor(f['id'], :label)
      if t = f.at(ns("./title"))
        t.children = "#{t.children.to_xml}"
      end
      prefix_name(f, "<br/><br/>", lbl, "title")
    end

      include Init
    end
  end
end

