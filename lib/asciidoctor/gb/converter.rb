require "asciidoctor"
require "asciidoctor/iso/converter"
require "isodoc/gb/common"
require "isodoc/gb/word_convert"
require "isodoc/gb/pdf_convert"
require "isodoc/gb/presentation_xml_convert"
require "gb_agencies"
require_relative "./section_input.rb"
require_relative "./front.rb"
require_relative "./validate.rb"
require_relative "cleanup.rb"
require "fileutils"

module Asciidoctor
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class Converter < ISO::Converter
      XML_ROOT_TAG = "gb-standard".freeze
      XML_NAMESPACE = "https://www.metanorma.org/ns/gb".freeze

      register_for "gb"

      def makexml(node)
        @draft = node.attributes.has_key?("draft")
        @keepboilerplate = node.attributes.has_key?("keep-boilerplate")
        super
      end

      def gb_attributes(node)
        {
          standardlogoimg: node.attr("standard-logo-img"),
          standardclassimg: node.attr("standard-class-img"),
          standardissuerimg: node.attr("standard-issuer-img"),
          titlefont: node.attr("title-font"),
        }
      end

      def html_extract_attributes(node)
        super.merge(gb_attributes(node))
      end

      def doc_extract_attributes(node)
        super.merge(gb_attributes(node))
      end

      def html_converter(node)
        node.nil? ? IsoDoc::Gb::HtmlConvert.new({}) :
          IsoDoc::Gb::HtmlConvert.new(html_extract_attributes(node))
      end

      def html_compliant_converter(node)
        node.nil? ? IsoDoc::Gb::HtmlConvert.new({}) :
          IsoDoc::Gb::HtmlConvert.new(html_extract_attributes(node).
                                      merge(compliant: true))
      end

      def doc_converter(node)
        node.nil? ? IsoDoc::Gb::WordConvert.new({}) :
          IsoDoc::Gb::WordConvert.new(doc_extract_attributes(node))
      end

      def pdf_converter(node)
        return nil if node.attr("no-pdf")
        node.nil? ? IsoDoc::Gb::PdfConvert.new({}) :
          IsoDoc::Gb::PdfConvert.new(doc_extract_attributes(node))
      end

      def presentation_xml_converter(node)
        node.nil? ? IsoDoc::Gb::PresentationXMLConvert.new({}) :
          IsoDoc::Gb::PresentationXMLConvert.new(html_extract_attributes(node))
      end

      def outputs(node, ret)
        File.open(@filename + ".xml", "w:UTF-8") { |f| f.write(ret) }
        presentation_xml_converter(node).convert(@filename + ".xml")
        html_compliant_converter(node).
          convert(@filename + ".presentation.xml", 
                  nil, false, "#{@filename}_compliant.html")
        html_converter(node).convert(@filename + ".presentation.xml", 
                                     nil, false, "#{@filename}.html")
        doc_converter(node).convert(@filename + ".presentation.xml", 
                                    nil, false, "#{@filename}.doc")
        pdf_converter(node)&.convert(@filename + ".presentation.xml", 
                                     nil, false, "#{@filename}.pdf")
      end

      def inline_quoted(node)
        ret = noko do |xml|
          case node.role
          when "en" then xml.string node.text, **{ language: "en" }
          when "zh" then xml.string node.text, **{ language: "zh" }
          when "zh-Hans"
            xml.string node.text, **{ language: "zh", script: "Hans" }
          when "zh-Hant"
            xml.string node.text, **{ language: "zh", script: "Hant" }
          else
            nil
          end
        end.join
        return ret unless ret.nil? or ret.empty?
        super
      end

      GBCODE = "((AQ|BB|CB|CH|CJ|CY|DA|DB|DL|DZ|EJ|FZ|GA|GH|GM|GY|HB|HG|"\
        "HJ|HS|HY|JB|JC|JG|JR|JT|JY|LB|LD|LS|LY|MH|MT|MZ|NY|QB|QC|QJ|"\
        "QZ|SB|SC|SH|SJ|SN|SY|TB|TD|TJ|TY|WB|WH|WJ|WM|WS|WW|XB|YB|YC|"\
        "YD|YS|YY|YZ|ZY|GB|GBZ|GJB|GBn|GHZB|GWKB|GWPB|JJF|JJG|Q|T)(/Z|/T)?)"

      ISO_REF = %r{^<ref\sid="(?<anchor>[^"]+)">
      \[(?<usrlbl>\([^)]+\))?(?<code>(ISO|IEC|#{GBCODE})[^0-9]*\s[0-9-]+?)
      ([:-](?<year>(19|20)[0-9][0-9]))?\]</ref>,?\s
      (?<text>.*)$}xm

      ISO_REF_NO_YEAR = %r{^<ref\sid="(?<anchor>[^"]+)">
      \[(?<usrlbl>\([^)]+\))?(?<code>(ISO|IEC|#{GBCODE})[^0-9]*\s[0-9-]+):--\]</ref>,?\s?
      <fn[^>]*>\s*<p>(?<fn>[^\]]+)</p>\s*</fn>,?\s?(?<text>.*)$}xm

      ISO_REF_ALL_PARTS = %r{^<ref\sid="(?<anchor>[^"]+)">
      \[(?<usrlbl>\([^)]+\))?(?<code>(ISO|IEC|#{GBCODE})[^0-9]*\s[0-9]+)\s
      \(all\sparts\)\]</ref>(<p>)?,?\s?
      (?<text>.*)(</p>)?$}xm

      def reference1_matches(item)
        matched = ISO_REF.match item
        matched2 = ISO_REF_NO_YEAR.match item
        matched3 = ISO_REF_ALL_PARTS.match item
        [matched, matched2, matched3]
      end

      def fetch_ref(xml, code, year, **opts)
        code = "CN(#{code})" if !/^CN\(/.match(code) &&
          /^#{GBCODE}[^A-Za-z]/.match(code)
          super
      end
    end
  end
end
