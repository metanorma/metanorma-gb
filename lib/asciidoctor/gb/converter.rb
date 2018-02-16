require "asciidoctor"
require "asciidoctor/gb/version"
require "asciidoctor/gb/gbconvert"
require "asciidoctor/iso/converter"
require_relative "./section.rb"
require_relative "./front.rb"
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

      def content_validate(doc)
        super
        bilingual_terms_validate(doc.root)
        doc_converter.gbtype_validate(doc.root)
      end

      def check_bilingual(t, element)
        zh = t.at(".//#{element}[@language = 'zh']")
        en = t.at(".//#{element}[@language = 'en']")
        (en.nil? || en.text.empty?) && !(zh.nil? || zh.text.empty?) &&
          warn("GB: #{element} term #{zh.text} has no English counterpart")
        !(en.nil? || en.text.empty?) && (zh.nil? || zh.text.empty?) &&
          warn("GB: #{element} term #{en.text} has no Chinese counterpart")
      end

      def bilingual_terms_validate(root)
        root.xpath("//term").each do |t|
          check_bilingual(t, "preferred")
          check_bilingual(t, "admitted")
          check_bilingual(t, "deprecates")
        end
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

      def termdef_cleanup(xmldoc)
        super
        termdef_localisedstr(xmldoc)
      end

      ROMAN_TEXT = /\s*[a-z\u00c0-\u00d6\u00d8-\u00f0\u0100-\u0240]/i
      HAN_TEXT = /\s*[\u4e00-\u9fff]+/

      def termdef_localisedstr(xmldoc)
        xmldoc.xpath("//admitted | //deprecates | //preferred").each do |zh|
          if zh.at("./string")
            extract_localisedstrings(zh)
          else
            duplicate_localisedstrings(zh)
          end
        end
      end

      # element consists solely of localised strings, with no attributes
      def extract_localisedstrings(elem)
        elem.xpath("./string").each do |s|
          s.name = elem.name
        end
        elem.replace(elem.children)
      end

      def duplicate_localisedstrings(zh)
        en = zh.dup.remove
        zh.after(en).after(" ")
        zh["language"] = "zh"
        en["language"] = "en"
        en.traverse do |c|
          c.text? && c.content = c.text.gsub(HAN_TEXT, "").gsub(/^\s*/, "")
        end
        zh.traverse do |c| 
          c.text? && c.content = c.text.gsub(ROMAN_TEXT, "").gsub(/^\s*/, "")
        end
      end

      def inline_quoted(node)
        noko do |xml|
          case node.type
          when :emphasis then xml.em node.text
          when :strong then xml.strong node.text
          when :monospaced then xml.tt node.text
          when :double then xml << "\"#{node.text}\""
          when :single then xml << "'#{node.text}'"
          when :superscript then xml.sup node.text
          when :subscript then xml.sub node.text
          when :asciimath then xml.stem node.text, **{ type: "AsciiMath" }
          else
            case node.role
            when "alt" then xml.admitted { |a| a << node.text }
            when "deprecated" then xml.deprecates { |a| a << node.text }
            when "domain" then xml.domain { |a| a << node.text }
            when "strike" then xml.strike node.text
            when "smallcap" then xml.smallcap node.text
            when "en" then xml.string node.text, **{ language: "en" }
            when "zh" then xml.string node.text, **{ language: "zh" }
            else
              xml << node.text
            end
          end
        end.join
      end

    end
  end
end
