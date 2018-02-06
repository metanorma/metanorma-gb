require "asciidoctor"
require "asciidoctor/gb/version"
require "asciidoctor/gb/gbconvert"
require "asciidoctor/iso/converter"
require "pp"

module Asciidoctor
  module Gb
    GB_NAMESPACE = "http://riboseinc.com/gbstandard"

    # A {Converter} implementation that generates CSD output, and a document
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
        ret1.root.add_namespace(nil, GB_NAMESPACE)
        ret1
      end

      def validate(doc)
        content_validate(doc)
        schema_validate(doc, File.join(File.dirname(__FILE__), "gbstandard.rng"))
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
          xml.title **{ language: lang } do |t|
            if node.attr("title-intro-#{lang}")
              t.title_intro { |t1| t1 << node.attr("title-intro-#{lang}") }
            end
            t.title_main { |t1| t1 << node.attr("title-main-#{lang}") }
            if node.attr("title-part-#{lang}")
              t.title_part node.attr("title-part-#{lang}")
            end
          end
        end
      end

      def title_intro_validate(root)
        title_intro_en = root.at("//title[@language='en']/title-intro")
        title_intro_zh = root.at("//title[@language='zh']/title-intro")
        if title_intro_en.nil? && !title_intro_zh.nil?
          warn "No English Title Intro!"
        end
        if !title_intro_en.nil? && title_intro_zh.nil?
          warn "No Chinese Title Intro!"
        end
      end

      def title_part_validate(root)
        title_part_en = root.at("//title[@language='en']/title-part")
        title_part_fr = root.at("//title[@language='zh']/title-part")
        if title_part_en.nil? && !title_part_fr.nil?
          warn "No English Title Part!"
        end
        if !title_part_en.nil? && title_part_fr.nil?
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



    end
  end
end
