require_relative "init"
require "isodoc"

module IsoDoc
  module Gb
    class PresentationXMLConvert < IsoDoc::Iso::PresentationXMLConvert
      def example1(f)
        n = @xrefs.get[f["id"]]
        lbl = (n.nil? || n[:label].nil? || n[:label].empty?) ? @example_lbl :
          l10n("#{@example_lbl} #{n[:label]}")
        prefix_name(f, "&nbsp;&mdash; ", l10n(lbl + ":"), "name")
      end

      def clause1(f)
        level = @xrefs.anchor(f['id'], :level, false) || "1"
        t = f.at(ns("./title")) and t["depth"] = level
        return unless f.ancestors("boilerplate").empty?
        return if @suppressheadingnumbers || f["unnumbered"]
        lbl = @xrefs.anchor(f['id'], :label,
                            f.parent.name != "sections") or return
        prefix_name(f, "&#x3000;", "#{lbl}#{clausedelim}", "title")
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

