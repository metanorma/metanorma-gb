require "isodoc"

module Asciidoctor
  module Gb
    # A {Converter} implementation that generates CSD output, and a document
    # schema encapsulation of the document for validation
    class GbConvert < IsoDoc::Convert
      def initialize(options)
        super
      end

      def title(isoxml, _out)
        intro = isoxml.at(ns("//title[@language='zh']/title-intro"))
        main = isoxml.at(ns("//title[@language='zh']/title-main"))
        part = isoxml.at(ns("//title[@language='zh']/title-part"))
        partnumber = isoxml.at(ns("//id/project-number/@part"))
        main = compose_title(main, intro, part, partnumber)
        set_metadata(:doctitle, main)
      end

      def subtitle(isoxml, _out)
        intro = isoxml.at(ns("//title[@language='en']/title-intro"))
        main = isoxml.at(ns("//title[@language='en']/title-main"))
        part = isoxml.at(ns("//title[@language='en']/title-part"))
        partnumber = isoxml.at(ns("//id/project-number/@part"))
        main = compose_title(main, intro, part, partnumber)
        set_metadata(:docsubtitle, main)
      end

      def note_label(node)
        n = get_anchors()[node["id"]]
        return "NOTE" if n.nil?
        n[:label]
      end

      def figure_key(out)
        out.p do |p|
          p.b { |b| b << "Key" }
        end
      end

      def formula_where(dl, out)
        out.p { |p| p << "where" }
        parse(dl, out)
      end

      def figure_get_or_make_dl(t)
        dl = t.at(".//dl")
        if dl.nil?
          t.add_child("<p><b>Key</b></p><dl></dl>")
          dl = t.at(".//dl")
        end
        dl
      end 

      def compose_title(main, intro, part, partnumber)
        c = HTMLEntities.new
        main = c.encode(main.text, :hexadecimal)
        intro &&
          main = "#{c.encode(intro.text, :hexadecimal)}&nbsp;&mdash; #{main}"
        part &&
          main = "#{main}&nbsp;&mdash; Part&nbsp;#{partnumber}: "\
          "#{c.encode(part.text, :hexadecimal)}"
        main
      end

      def populate_template(docxml)
        meta = get_metadata
        docxml.
          gsub(/DOCYEAR/, meta[:docyear]).
          gsub(/DOCNUMBER/, meta[:docnumber]).
          gsub(/TCNUM/, meta[:tc]).
          gsub(/SCNUM/, meta[:sc]).
          gsub(/WGNUM/, meta[:wg]).
          gsub(/DOCTITLE/, meta[:doctitle]).
          gsub(/DOCSUBTITLE/, meta[:docsubtitle]).
          gsub(/SECRETARIAT/, meta[:secretariat]).
          gsub(/[ ]?DRAFTINFO/, meta[:draftinfo]).
          gsub(/\[TERMREF\]\s*/, "[SOURCE: ").
          gsub(/\s*\[\/TERMREF\]\s*/, "]").
          gsub(/\s*\[ISOSECTION\]/, ", ").
          gsub(/\s*\[MODIFICATION\]/, ", modified &mdash; ").
          gsub(%r{WD/CD/DIS/FDIS}, meta[:stageabbr])
      end

      NORM_WITH_REFS_PREF = <<~BOILERPLATE
          The following documents are referred to in the text in such a way
          that some or all of their content constitutes requirements of this
          document. For dated references, only the edition cited applies.
          For undated references, the latest edition of the referenced
          document (including any amendments) applies.
      BOILERPLATE

      NORM_EMPTY_PREF =
        "There are no normative references in this document."

      def norm_ref(isoxml, out)
        q = "//sections/references[title = 'Normative References']"
        f = isoxml.at(ns(q)) or return
        out.div do |div|
          clause_name("2.", "Normative References", div, false)
          norm_ref_preface(f, div)
          biblio_list(f, div, false)
        end
      end

      def bibliography(isoxml, out)
        q = "//sections/references[title = 'Bibliography']"
        f = isoxml.at(ns(q)) or return
        page_break(out)
        out.div do |div|
          div.h1 "Bibliography", **{ class: "Section3" }
          f.elements.reject do |e|
            ["reference", "title", "bibitem"].include? e.name
          end.each { |e| parse(e, div) }
          biblio_list(f, div, true)
        end
      end

      def scope(isoxml, out)
        f = isoxml.at(ns("//clause[title = 'Scope']")) || return
        out.div do |div|
          clause_name("1.", "Scope", div, false)
          f.elements.each do |e|
            parse(e, div) unless e.name == "title"
          end
        end
      end

      def terms_defs(isoxml, out)
        f = isoxml.at(ns("//terms")) || return
        out.div do |div|
          clause_name("3.", "Terms and Definitions", div, false)
          f.elements.each do |e|
            parse(e, div) unless e.name == "title"
          end
        end
      end

      def symbols_abbrevs(isoxml, out)
        f = isoxml.at(ns("//symbols-abbrevs")) || return
        out.div do |div|
          clause_name("4.", "Symbols and Abbreviations", div, false)
          f.elements.each do |e|
            parse(e, div) unless e.name == "title"
          end
        end
      end

      def introduction(isoxml, out)
        f = isoxml.at(ns("//content[title = 'Introduction']")) || return
        title_attr = { class: "IntroTitle" }
        page_break(out)
        out.div **{ class: "Section3" } do |div|
          div.h1 "Introduction", **attr_code(title_attr)
          f.elements.each do |e|
            if e.name == "patent-notice"
              e.elements.each { |e1| parse(e1, div) }
            else
              parse(e, div) unless e.name == "title"
            end
          end
        end
      end

      def foreword(isoxml, out)
        f = isoxml.at(ns("//content[title = 'Foreword']")) || return
        page_break(out)
        out.div do |s|
          s.h1 **{ class: "ForewordTitle" } { |h1| h1 << "Foreword" }
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      def deprecated_term_parse(node, out)
        out.p **{ class: "AltTerms" } do |p|
          p << "DEPRECATED: #{node.text}"
        end
      end

      def termexample_parse(node, out)
        out.div **{ class: "Note" } do |div|
          first = node.first_element_child
          div.p **{ class: "Note" } do |p|
            p << "EXAMPLE:"
            insert_tab(p, 1)
            para_then_remainder(first, node, p)
          end
        end
      end

      STAGE_ABBRS = {
        "00": "PWI",
        "10": "NWIP",
        "20": "WD",
        "30": "CD",
        "40": "DIS",
        "50": "FDIS",
        "60": "IS",
        "90": "(Review)",
        "95": "(Withdrawal)",
      }.freeze

      def initial_anchor_names(d)
        introduction_names(d.at(ns("//content[title = 'Introduction']")))
        section_names(d.at(ns("//clause[title = 'Scope']")), "1", 1)
        section_names(d.at(ns(
          "//references[title = 'Normative References']")), "2", 1)
        section_names(d.at(ns("//terms")), "3", 1)
        middle_section_asset_names(d)
      end

      def middle_section_asset_names(d)
        middle_sections = "//clause[title = 'Scope'] | "\
          "//references[title = 'Normative References'] | //terms | "\
          "//symbols-abbrevs | //clause[parent::sections]"
        sequential_asset_names(d.xpath(ns(middle_sections)))
      end

      def clause_names(docxml,sect_num)
        q = "//clause[parent::sections][not(xmlns:title = 'Scope')]"
        docxml.xpath(ns(q)).each_with_index do |c, i|
          section_names(c, (i + sect_num).to_s, 1)
        end
      end

      def termnote_anchor_names(docxml)
        docxml.xpath(ns("//term[termnote]")).each do |t|
          t.xpath(ns("./termnote")).each_with_index do |n, i|
            @anchors[n["id"]] = { label: "Note #{i + 1} to entry",
                                  xref: "#{@anchors[t["id"]][:xref]},"\
                                  "Note #{i + 1}" }
          end
        end
      end

      def table_note_anchor_names(docxml)
        docxml.xpath(ns("//table[note]")).each do |t|
          t.xpath(ns("./note")).each_with_index do |n, i|
            @anchors[n["id"]] = { label: "NOTE #{i + 1}",
                                  xref: "#{@anchors[t["id"]][:xref]},"\
                                  "Note #{i + 1}" }
          end
        end
      end

      def sequential_figure_names(clause)
        i = j = 0
        clause.xpath(ns(".//figure")).each do |t|
          label = "Figure #{i}" + ( j.zero? ? "" : "-#{j}" )
          if t.parent.name == "figure"
            j += 1
          else
            j = 0
            i += 1
          end
          label = "Figure #{i}" + ( j.zero? ? "" : "-#{j}" )
          @anchors[t["id"]] = { label: label, xref: label }
        end
      end

      def sequential_asset_names(clause)
        clause.xpath(ns(".//table")).each_with_index do |t, i|
          @anchors[t["id"]] = { label: "Table #{i + 1}",
                                xref: "Table #{i + 1}" }
        end
        sequential_figure_names(clause)
        clause.xpath(ns(".//formula")).each_with_index do |t, i|
          @anchors[t["id"]] = { label: (i + 1).to_s,
                                xref: "Formula #{i + 1}" }
        end
      end

      def hierarchical_figure_names(clause, num)
        i = j = 0
        clause.xpath(ns(".//figure")).each do |t|
          if t.parent.name == "figure"
            j += 1
          else
            j = 0
            i += 1
          end
          label = "Figure #{num}.#{i}" + ( j.zero? ? "" : "-#{j}" )
          @anchors[t["id"]] = { label: label, xref: label }
        end
      end

      def hierarchical_asset_names(clause, num)
        clause.xpath(ns(".//table")).each_with_index do |t, i|
          @anchors[t["id"]] = { label: "Table #{num}.#{i + 1}",
                                xref: "Table #{num}.#{i + 1}" }
        end
        hierarchical_figure_names(clause, num)
        clause.xpath(ns(".//formula")).each_with_index do |t, i|
          @anchors[t["id"]] = { label: "#{num}.#{i + 1}",
                                xref: "Formula #{num}.#{i + 1}" }
        end
      end

      def section_names(clause, num, level)
        @anchors[clause["id"]] = { label: num, xref: "Clause #{num}",
                                   level: level }
        clause.xpath(ns("./subsection | ./term")).each_with_index do |c, i|
          section_names1(c, "#{num}.#{i + 1}", level + 1)
        end
      end

      def section_names1(clause, num, level)
        @anchors[clause["id"]] =
          { label: num, level: level,
            xref: clause.name == "term" ? num : "Clause #{num}" }
        clause.xpath(ns("./subsection ")).
          each_with_index do |c, i|
          section_names1(c, "#{num}.#{i + 1}", level + 1)
        end
      end

      def annex_names(clause, num)
        obligation = "(Informative)"
        obligation = "(Normative)" if clause["subtype"] == "normative"
        label = "<b>Annex #{num}</b><br/>#{obligation}"
        @anchors[clause["id"]] = { label: label,
                                   xref: "Annex #{num}", level: 1 }
        clause.xpath(ns("./subsection")).each_with_index do |c, i|
          annex_names1(c, "#{num}.#{i + 1}", 2)
        end
        hierarchical_asset_names(clause, num)
      end

      def format_ref(ref, isopub)
        return "ISO #{ref}" if isopub
        return "[#{ref}]" if /^\d+$/.match?(ref) && !/^\[.*\]$/.match?(ref)
        ref
      end

      def reference_names(ref)
        isopub = ref.at(ns("./publisher/affiliation[name = 'ISO']"))
        docid = ref.at(ns("./docidentifier"))
        return ref_names(ref) unless docid
        date = ref.at(ns("./publisherdate"))
        reference = format_ref(docid.text, isopub)
        reference += ": #{date.text}" if date && isopub
        @anchors[ref["id"]] = { xref: reference }
      end

      def error_parse(node, out)
        # catch elements not defined in ISO
        case node.name
        when "string" then string_parse(node, out)
        else
          super
        end
      end

      def string_parse(node, out)
        node.children.each { |c| parse(c, out) }
      end








    end
  end
end
