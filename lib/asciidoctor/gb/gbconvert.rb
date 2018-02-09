require "isodoc"
require_relative "./xref_gen.rb"

module Asciidoctor
  module Gb
    # A {Converter} implementation that generates CSD output, and a document
    # schema encapsulation of the document for validation
    class GbConvert < IsoDoc::Convert
      def initialize(options)
        super
      end

      def title(isoxml, _out)
        intro = isoxml.at(ns("//title-intro[@language='zh']"))
        main = isoxml.at(ns("//title-main[@language='zh']"))
        part = isoxml.at(ns("//title-part[@language='zh']"))
        partnumber = isoxml.at(ns("//project-number/@part"))
        main = compose_title(main, intro, part, partnumber, "zh")
        set_metadata(:doctitle, main)
      end

      def subtitle(isoxml, _out)
        intro = isoxml.at(ns("//title-intro[@language='en']"))
        main = isoxml.at(ns("//title-main[@language='en']"))
        part = isoxml.at(ns("//title-part[@language='en']"))
        partnumber = isoxml.at(ns("//project-number/@part"))
        main = compose_title(main, intro, part, partnumber, "en")
        set_metadata(:docsubtitle, main)
      end

      def note_label(node)
        n = get_anchors()[node["id"]]
        return "注" if n.nil?
        n[:label]
      end

      def figure_key(out)
        out.p do |p|
          p.b { |b| b << "Key" } # TODO: Chinese
        end
      end

      def formula_where(dl, out)
        out.p { |p| p << "where" } # TODO: Chinese
        parse(dl, out)
      end

      def figure_get_or_make_dl(t)
        dl = t.at(".//dl")
        if dl.nil?
          t.add_child("<p><b>Key</b></p><dl></dl>") # TODO: Chinese
          dl = t.at(".//dl")
        end
        dl
      end

      def part_label(partnumber, lang)
        case lang
        when "en" then "Part #{partnumber}"
        when "zh" then "第#{partnumber}部"
        end
      end

      def compose_title(main, intro, part, partnumber, lang)
        c = HTMLEntities.new
        main = c.encode(main.text, :hexadecimal)
        intro &&
          main = "#{c.encode(intro.text, :hexadecimal)}&nbsp;&mdash; #{main}"
        plabel = part_label(partnumber, lang)
        part &&
          main = "#{main}&nbsp;&mdash; #{plabel}: "\
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
          gsub(/\[TERMREF\]\s*/, "[SOURCE: "). # TODO: Chinese
          gsub(/\s*\[\/TERMREF\]\s*/, "]").
          gsub(/\s*\[ISOSECTION\]/, ", 定义").
          gsub(/\s*\[MODIFICATION\]/, ", 改写 &mdash; ").
          gsub(%r{WD/CD/DIS/FDIS}, meta[:stageabbr])
      end

      NORM_WITH_REFS_PREF = <<~BOILERPLATE
          下列文件对于本文件的应用是必不可少的。
          凡是注日期的引用文件，仅注日期的版本适用于本文件。
          凡是不注日期的引用文件，其最新版本（包括所有的修改单）适用于本文件。
      BOILERPLATE

      NORM_EMPTY_PREF =
        "本文件并没有规范性引用文件。"

      def norm_ref(isoxml, out)
        q = "./*/references/references[title = '规范性引用文件']"
        f = isoxml.at(ns(q)) or return
        out.div do |div|
          clause_name("2.", "规范性引用文件", div, false)
          norm_ref_preface(f, div)
          biblio_list(f, div, false)
        end
      end

      def bibliography(isoxml, out)
        q = "./*/references/references[title = '参考文献']"
        f = isoxml.at(ns(q)) or return
        page_break(out)
        out.div do |div|
          div.h1 "参考文献", **{ class: "Section3" }
          f.elements.reject do |e|
            ["reference", "title", "bibitem"].include? e.name
          end.each { |e| parse(e, div) }
          biblio_list(f, div, true)
        end
      end

      def scope(isoxml, out)
        f = isoxml.at(ns("//clause[title = '范围']")) || return
        out.div do |div|
          clause_name("1", "范围", div, false)
          f.elements.each do |e|
            parse(e, div) unless e.name == "title"
          end
        end
      end

      def terms_defs(isoxml, out)
        f = isoxml.at(ns("//terms")) || return
        out.div do |div|
          clause_name("3", "术语和定义", div, false)
          f.elements.each do |e|
            parse(e, div) unless e.name == "title"
          end
        end
      end

      def symbols_abbrevs(isoxml, out)
        f = isoxml.at(ns("//symbols-abbrevs")) || return
        out.div do |div|
          clause_name("4", "符号、代号和缩略语", div, false)
          f.elements.each do |e|
            parse(e, div) unless e.name == "title"
          end
        end
      end

      def introduction(isoxml, out)
        f = isoxml.at(ns("//introduction")) || return
        title_attr = { class: "IntroTitle" }
        page_break(out)
        out.div **{ class: "Section3" } do |div|
          div.h1 "引言", **attr_code(title_attr)
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
        f = isoxml.at(ns("//foreword")) || return
        page_break(out)
        out.div do |s|
          s.h1 **{ class: "ForewordTitle" } { |h1| h1 << "前言" }
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      def deprecated_term_parse(node, out)
        out.p **{ class: "AltTerms" } do |p|
          p << "DEPRECATED: #{node.text}" #TODO: Chinese
        end
      end

      def termexample_parse(node, out)
        out.div **{ class: "Note" } do |div|
          first = node.first_element_child
          div.p **{ class: "Note" } do |p|
            p << "示例:"
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
