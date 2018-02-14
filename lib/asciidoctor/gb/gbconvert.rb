require "isodoc"
require_relative "./xref_gen.rb"
require_relative "./metadata.rb"

module Asciidoctor
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class GbConvert < IsoDoc::Convert
      def initialize(options)
        super
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

      NORM_WITH_REFS_PREF = <<~BOILERPLATE
          下列文件对于本文件的应用是必不可少的。
          凡是注日期的引用文件，仅注日期的版本适用于本文件。
          凡是不注日期的引用文件，其最新版本（包括所有的修改单）适用于本文件。
      BOILERPLATE

      NORM_EMPTY_PREF =
        "本文件并没有规范性引用文件。"

      def norm_ref(isoxml, out)
        q = "./*/references[title = '规范性引用文件']"
        f = isoxml.at(ns(q)) or return
        out.div do |div|
          clause_name("2.", "规范性引用文件", div, false)
          norm_ref_preface(f, div)
          biblio_list(f, div, false)
        end
      end

      def bibliography(isoxml, out)
        q = "./*/references[title = '参考文献']"
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

      def clause(isoxml, out)
        isoxml.xpath(ns("//clause[parent::sections]")).each do |c|
          next if c.at(ns("./title")).text == "范围"
          out.div **attr_code(id: c["id"]) do |s|
            c.elements.each do |c1|
              if c1.name == "title"
                clause_name("#{get_anchors()[c['id']][:label]}.",
                            c1.text, s, c["inline-header"])
              else
                parse(c1, s)
              end
            end
          end
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

      def generate_header(filename, dir)
        header = File.read(@header, encoding: "UTF-8").
          gsub(/FILENAME/, filename).
          gsub(/DOCYEAR/, get_metadata()[:docyear]).
          gsub(/DOCIDENTIFIER/, get_metadata()[:docidentifier])
        File.open("header.html", "w") do |f|
          f.write(header)
        end
        system "cp #{File.join(File.dirname(__FILE__), File.join("html", "logo.png"))} logo.png"
        system "cp #{File.join(File.dirname(__FILE__), File.join("html", "footer.png"))} footer.png"
        system "cp #{File.join(File.dirname(__FILE__), File.join("html", "blank.png"))} blank.png"
      end
    end
  end
end
