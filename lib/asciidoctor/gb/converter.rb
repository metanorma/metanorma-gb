require "asciidoctor"
require "asciidoctor/gb/version"
require "asciidoctor/gb/gbconvert"
require "asciidoctor/iso/converter"
require_relative "./section.rb"
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

      ROMAN_TEXT = /\s*[a-z\u00c0-\u00d6\u00d8-\u00f0\u0100-\u0240]/i
      CHINESE_TEXT = /\s*[\u4e00-\u9fff]+/

      def termdef_localisedstr(xmldoc)
        xmldoc.xpath("//admitted | //deprecates | //preferred").each do |zh|
          # en = Nokogiri::XML.fragment(%{<#{x.name} lang="en"/>})
          # zh = Nokogiri::XML.fragment(%{<#{x.name} lang="zh"/>})
          en = zh.dup.remove
          zh.after(en).after(" ")
          zh["language"] = "zh"
          en["language"] = "en"
          en.traverse do |c|
            next unless c.text?
            c.content = c.text.gsub(CHINESE_TEXT, "").gsub(/^\s*/, "")
          end
          zh.traverse do |c| 
            next unless c.text?
            c.content = c.text.gsub(ROMAN_TEXT, "").gsub(/^\s*/, "")
          end
        end
      end
      
      
    end
  end
end
