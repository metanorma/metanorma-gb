require "asciidoctor"
require "asciidoctor/gb/version"
require "asciidoctor/gb/gbconvert"
require "asciidoctor/iso/converter"
require "pp"

module Asciidoctor
  module Gb
    GB_NAMESPACE = "http://riboseinc.com/gbstandard"

    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class Converter < ISO::Converter

      register_for "gb"

      def makexml(node)
        result = ["<?xml version='1.0' encoding='UTF-8'?>\n<gb-standard>"]
        @draft = node.attributes.has_key?("draft")
        result << noko { |ixml| front node, ixml }
        result << noko { |ixml| middle node, ixml }
        result << "</gb-standard>"
        result = textcleanup(result.flatten * "\n")
        ret1 = cleanup(Nokogiri::XML(result))
        validate(ret1)
        ret1.root.add_namespace(nil, GB_NAMESPACE)
        ret1
      end

      def validate(doc)
        content_validate(doc)
        schema_validate(formattedstr_strip(doc.dup),
                        File.join(File.dirname(__FILE__), "gbstandard.rng"))
      end

      def html_doc_path(file)
        File.join(File.dirname(__FILE__), File.join("html", file))
      end

      def doc_converter
        GbConvert.new(
          htmlstylesheet: html_doc_path("htmlstyle.css"),
          wordstylesheet: html_doc_path("wordstyle.css"),
          standardstylesheet: html_doc_path("gb.css"),
          header: html_doc_path("header.html"),
          htmlcoverpage: html_doc_path("html_gb_titlepage.html"),
          wordcoverpage: html_doc_path("word_gb_titlepage.html"),
          htmlintropage: html_doc_path("html_gb_intro.html"),
          wordintropage: html_doc_path("word_gb_intro.html"),
        )
      end

      def title(node, xml)
        ["en", "zh"].each do |lang|
          xml.title do |t|
            at = { language: lang, format: "plain" }
            node.attr("title-intro-#{lang}") and
              t.title_intro **attr_code(at) do |t1|
              t1 << node.attr("title-intro-#{lang}")
            end
            t.title_main **attr_code(at) do |t1|
              t1 << node.attr("title-main-#{lang}")
            end
            node.attr("title-part-#{lang}") and
              t.title_part **attr_code(at) do |t1|
              t1 << node.attr("title-part-#{lang}")
            end
          end
        end
      end

      def title_intro_validate(root)
        title_intro_en = root.at("//title-intro[@language='en']")
        title_intro_zh = root.at("//title-intro[@language='zh']")
        if title_intro_en.nil? && !title_intro_zh.nil?
          warn "No English Title Intro!"
        end
        if !title_intro_en.nil? && title_intro_zh.nil?
          warn "No Chinese Title Intro!"
        end
      end

      def title_part_validate(root)
        title_part_en = root.at("//title-part[@language='en']")
        title_part_zh = root.at("//title-part[@language='zh']")
        if title_part_en.nil? && !title_part_zh.nil?
          warn "No English Title Part!"
        end
        if !title_part_en.nil? && title_part_zh.nil?
          warn "No Chinese Title Part!"
        end
      end

      def termdef_cleanup(xmldoc)
        super
        termdef_localisedstr(xmldoc)
      end

      def termdef_localisedstr(xmldoc)
        xmldoc.xpath("//admitted | //deprecates | //preferred").each do |x|
          en = Nokogiri::XML.fragment('<string lang="en"></string>')
          zh = Nokogiri::XML.fragment('<string lang="zh"></string>')
          x1 = x.dup
          x.children.each { |c| en.child.add_child(c.remove) }
          x1.children.each { |c| zh.child.add_child(c.remove) }
          en.traverse do |c|
            c.content = c.text.gsub(/\s*[\u4e00-\u9fff]+/, "").gsub(/^\s*/, "") if c.text? 
          end
          zh.traverse do |c| 
            c.content = c.text.gsub(/\s*[a-z\u00c0-\u00d6\u00d8-\u00f0\u0100-\u0240]/i, "").gsub(/^\s*/, "")  if c.text? 
          end
          en.parent = x
          x.add_child(" ")
          zh.parent = x
        end
      end

      def section(node)
        a = { id: Asciidoctor::ISO::Utils::anchor_or_uuid(node) }
        noko do |xml|
          case node.title
          when "引言" then
            if node.level == 1
              introduction_parse(a, xml, node)
            else
              clause_parse(a, xml, node)
            end
          when "patent notice" then patent_notice_parse(xml, node)
          when "范围" then scope_parse(a, xml, node)
          when "规范性引用文件" then norm_ref_parse(a, xml, node)
          when "术语和定义"
            term_def_parse(a, xml, node, node.title.downcase)
          when "terms, definitions, symbols and abbreviations" # TODO: Chinese
            term_def_parse(a, xml, node, node.title.downcase)
          when "符号、代号和缩略语"
            symbols_parse(a, xml, node)
          when "参考文献" then bibliography_parse(a, xml, node)
          else
            if @term_def
              term_def_subclause_parse(a, xml, node)
            elsif @biblio
              bibliography_parse(a, xml, node)
            elsif node.attr("style") == "appendix" && node.level == 1
              annex_parse(a, xml, node)
            else
              clause_parse(a, xml, node)
            end
          end
        end.join("\n")
      end
      
      def preamble(node)
        noko do |xml|
          xml.foreword do |xml_abstract|
            xml_abstract.title { |t| t << "前言" }
            content = node.content
            xml_abstract << content
            text = Asciidoctor::ISO::Utils::flatten_rawtext(content).join("\n")
            foreword_style(node, text)
          end
        end.join("\n")
      end

      # spec of permissible section sequence
      SEQ = [
        {
          msg: "Initial section must be (content) Foreword",
          val:  [{ tag: "foreword", title: "前言" }],
        },
        {
          msg: "Prefatory material must be followed by (clause) Scope",
          val:  [{ tag: "introduction", title: "引言" },
                 { tag: "clause", title: "范围" }],
        },
        {
          msg: "Prefatory material must be followed by (clause) Scope",
          val: [{ tag: "clause", title: "范围" }],
        },
        # we skip normative references, it goes to end of list
        #{
          #msg: "Scope must be followed by Normative References",
          #val: [{ tag: "references", title: "Normative References" }]
        #},
        {
          msg: "Normative References must be followed by "\
          "Terms and Definitions",
          val: [
            { tag: "terms", title: "术语和定义" },
            { tag: "terms",
              title: "Terms, Definitions, Symbols and Abbreviations" } # TODO: Chinese
          ]
        },
      ]

      def sections_sequence_validate(root)
        f = root.xpath(" //foreword | //introduction | //sections/terms | "\
                       "//sections/clause | ./references | "\
                       "./annex")
        names = f.map { |s| { tag: s.name, title: s.at("./title").text } }
        names = seqcheck(names, SEQ[0][:msg], SEQ[0][:val]) or return
        n = names[0]
        names = seqcheck(names, SEQ[1][:msg], SEQ[1][:val]) or return
        if n == { tag: "introduction", title: "引言" }
          names = seqcheck(names, SEQ[2][:msg], SEQ[2][:val]) or return
        end
        # names = seqcheck(names, SEQ[3][:msg], SEQ[3][:val]) or return
        names = seqcheck(names, SEQ[3][:msg], SEQ[3][:val]) or return
        n = names.shift
        if n == { tag: "clause", title: "符号、代号和缩略语" }
          n = names.shift or return
        end
        n[:tag] == "clause" or
          warn "ISO style: Document must contain at least one clause"
        n == { tag: "clause", title: "Scope" } and
          warn "ISO style: Scope must occur before Terms and Definitions"
        n = names.shift or return
        while n[:tag] == "clause"
          n[:title] == "范围" and
            warn "ISO style: Scope must occur before Terms and Definitions"
          n[:title] == "符号、代号和缩略语" and
            warn "ISO style: Symbols and Abbreviations must occur "\
            "right after Terms and Definitions"
          n = names.shift or return
        end
        unless n[:tag] == "annex" or n[:tag] == "references"
          warn "ISO style: Only annexes and references can follow clauses"
        end
        while n[:tag] == "annex"
          n = names.shift or return
        end
        n == { tag: "references", title: "规范性引用文件" } or
          warn "ISO style: Document must include (references) Normative References"
        n = names.shift
        n == { tag: "references", title: "参考文献" } or
          warn "ISO style: Final section must be (references) Bibliography"
        names.empty? or
          warn "ISO style: There are sections after the final Bibliography"
      end


    end
  end
end
