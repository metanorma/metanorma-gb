module IsoDoc
  module Gb
    class Common < IsoDoc::Common
      # putting in tab so that ToC aligns
      def foreword(isoxml, out)
        f = isoxml.at(ns("//foreword")) || return
        page_break(out)
        out.div do |s|
          s.h1 **{ class: "ForewordTitle" } do |h1|
            h1 << "#{@foreword_lbl}&nbsp;"
            # insert_tab(h1, 1)
          end
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      def clause_name(num, title, div, header_class)
        header_class = {} if header_class.nil?
        div.h1 **attr_code(header_class) do |h1|
          if num
            h1 << num
            h1 << "&#x3000;"
          end
          h1 << title
        end
        div.parent.at(".//h1")
      end

      def clause_parse_title(node, div, c1, out)
        if node["inline-header"] == "true"
          inline_header_title(out, node, c1)
        else
          div.send "h#{get_anchors[node['id']][:level]}" do |h|
            h << "#{get_anchors[node['id']][:label]}.&#x3000;"
            c1.children.each { |c2| parse(c2, h) }
          end
        end
      end

      def annex_name(annex, name, div)
        div.h1 **{ class: "Annex" } do |t|
          t << "#{get_anchors[annex['id']][:label]}<br/><br/>"
          t << name.text
        end
      end

      def term_defs_boilerplate(div, source, term, preface)
        if source.empty? && term.nil?
          div << @no_terms_boilerplate
        else
          div << term_defs_boilerplate_cont(source, term)
        end
        div << @term_def_boilerplate unless preface
      end
    end
  end
end
