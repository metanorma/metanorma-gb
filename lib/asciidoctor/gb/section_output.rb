module Asciidoctor
  module Gb
    class GbConvert < IsoDoc::Convert

      NORM_WITH_REFS_PREF = <<~BOILERPLATE
          下列文件对于本文件的应用是必不可少的。
          凡是注日期的引用文件，仅注日期的版本适用于本文件。
          凡是不注日期的引用文件，其最新版本（包括所有的修改单）适用于本文件。
      BOILERPLATE

      NORM_EMPTY_PREF =
        "本文件并没有规范性引用文件。"

      def norm_ref(isoxml, out)
        q = "./*/references[title = '规范性引用文件']"
        (f = isoxml.at(ns(q))) || return
        out.div do |div|
          clause_name("2.", "规范性引用文件", div, false, nil)
          norm_ref_preface(f, div)
          biblio_list(f, div, false)
        end
      end

      def bibliography(isoxml, out)
        q = "./*/references[title = '参考文献']"
        (f = isoxml.at(ns(q))) || return
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
          clause_name("1", "范围", div, false, nil)
          f.elements.each do |e|
            parse(e, div) unless e.name == "title"
          end
        end
      end

      def term_defs_boilerplate(div, source, term)
        if source.nil? && term.nil?
          div << "<p>本文件不提供术语和定义。</p>"
        else
          out = term_defs_boilerplate_cont(source, term)
          div << out
        end
      end

      def term_defs_boilerplate_cont(src, term)
sources = sentence_join(src.map { |s| s["citeas"] })
if src.nil?
          "<p>下列术语和定义适用于本文件。</p>"
        elsif term.nil?
          "<p>#{sources} 界定的术语和定义适用于本文件。</p>"
        else
          "<p>#{sources} 界定的以及下列术语和定义适用于本文件。</p>"
        end
      end

      def terms_defs(isoxml, out)
        f = isoxml.at(ns("//terms")) || return
        out.div **attr_code(id: f["id"]) do |div|
          clause_name("3", "术语和定义", div, false, nil)
          term_defs_boilerplate(div, f.xpath(ns("./source")), f.at(ns(".//term")))
          f.elements.each do |e|
            parse(e, div) unless %w{title source}.include? e.name
          end
        end
      end

      def symbols_abbrevs(isoxml, out)
        f = isoxml.at(ns("//symbols-abbrevs")) || return
        out.div **attr_code(id: f["id"], class: "Symbols") do |div|
          clause_name("4", "符号、代号和缩略语", div, false, nil)
          f.elements.each do |e|
            parse(e, div) unless e.name == "title"
          end
        end
      end

      def introduction(isoxml, out)
        f = isoxml.at(ns("//introduction")) || return
        num = f.at(ns(".//subsection")) ? "0." : nil
        title_attr = { class: "IntroTitle" }
        page_break(out)
        out.div **{ class: "Section3", id: f["id"] } do |div|
          clause_name(num, "引言", div, false, title_attr)
          f.elements.each do |e|
            if e.name == "patent-notice"
              e.elements.each { |e1| parse(e1, div) }
            else
              parse(e, div) unless e.name == "title"
            end
          end
        end
      end

      # putting in tab so that ToC aligns
      def foreword(isoxml, out)
        f = isoxml.at(ns("//foreword")) || return
        page_break(out)
        out.div do |s|
          s.h1 **{ class: "ForewordTitle" } do |h1|
            h1 << "前言"
            insert_tab(h1, 1)
          end
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
                            c1.text, s, c["inline-header"], nil)
              else
                parse(c1, s)
              end
            end
          end
        end
      end
    end
  end
end
