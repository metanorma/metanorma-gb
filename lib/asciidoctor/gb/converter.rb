require "asciidoctor"
require "asciidoctor/gb/version"
require "asciidoctor/gb/gbconvert"
require "asciidoctor/iso/converter"
require_relative "./section_input.rb"
require_relative "./front.rb"
require_relative "./validate.rb"
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

      def html_doc_path(file)
        File.join(File.dirname(__FILE__), File.join("html", file))
      end

      def html_converter(node)
        GbConvert.new(
          htmlstylesheet: generate_css(html_doc_path("htmlstyle.scss"), true),
          standardstylesheet: generate_css(html_doc_path("gb.scss"), true),
          htmlcoverpage: html_doc_path("html_gb_titlepage.html"),
          htmlintropage: html_doc_path("html_gb_intro.html"),
          i18nyaml: node&.attr("i18nyaml"),
        )
      end

      def doc_converter(node)
        GbWordConvert.new(
          wordstylesheet: generate_css(html_doc_path("wordstyle.scss"), false),
          standardstylesheet: generate_css(html_doc_path("gb.scss"), false),
          wordcoverpage: html_doc_path("word_gb_titlepage.html"),
          wordintropage: html_doc_path("word_gb_intro.html"),
          header: html_doc_path("header.html"),
          i18nyaml: node&.attr("i18nyaml"),
        )
      end

      def default_fonts(node)
        b = node.attr("body-font") ||
          (node.attr("script") == "Hans" ? '"SimSun",serif' :
           node.attr("script") == "Latn" ? '"Cambria",serif' : '"SimSun",serif' )
        h = node.attr("header-font") ||
          (node.attr("script") == "Hans" ? '"SimHei",sans-serif' :
           node.attr("script") == "Latn" ? '"Calibri",sans-serif' : '"SimHei",sans-serif' )
        m = node.attr("monospace-font") || '"Courier New",monospace'
        scope = node.attr("scope") || "national"
        t = node.attr("title-font") ||
          scope == "national" ? '"SimSun",serif' : '"SimHei",sans-serif'
        "$bodyfont: #{b};\n$headerfont: #{h};\n$monospacefont: #{m};\n$titlefont: #{t};\n"
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
            when "zh-Hans"
              xml.string node.text, **{ language: "zh", script: "Hans" }
            when "zh-Hant"
              xml.string node.text, **{ language: "zh", script: "Hant" }
            else
              xml << node.text
            end
          end
        end.join
      end

      def termdef_boilerplate_cleanup(xmldoc)
        nil
      end

      GBCODE = "((AQ|BB|CB|CH|CJ|CY|DA|DB|DL|DZ|EJ|FZ|GA|GH|GM|GY|HB|HG|"\
        "HJ|HS|HY|JB|JC|JG|JR|JT|JY|LB|LD|LS|LY|MH|MT|MZ|NY|QB|QC|QJ|"\
        "QZ|SB|SC|SH|SJ|SN|SY|TB|TD|TJ|TY|WB|WH|WJ|WM|WS|WW|XB|YB|YC|"\
        "YD|YS|YY|YZ|ZY|GB|GBZ|GJB|GBn|GHZB|GWKB|GWPB|JJF|JJG)(/Z|/T)?)"

      ISO_REF = %r{^<ref\sid="(?<anchor>[^"]+)">
      \[(?<code>(ISO|IEC|#{GBCODE})[^0-9]*\s[0-9-]+)(:(?<year>[0-9]+))?\]</ref>,?\s
      (?<text>.*)$}xm

      ISO_REF_NO_YEAR = %r{^<ref\sid="(?<anchor>[^"]+)">
      \[(?<code>(ISO|IEC|#{GBCODE})[^0-9]*\s[0-9-]+):--\]</ref>,?\s?
      <fn[^>]*>\s*<p>(?<fn>[^\]]+)</p>\s*</fn>,?\s?(?<text>.*)$}xm

      # TODO: all parts in ZH
      ISO_REF_ALL_PARTS = %r{^<ref\sid="(?<anchor>[^"]+)">
      \[(?<code>(ISO|IEC|#{GBCODE})[^0-9]*\s[0-9]+)\s\(all\sparts\)\]</ref>(<p>)?,?\s?
      (?<text>.*)(</p>)?$}xm

      def reference1_matches(item)
        matched = ISO_REF.match item
        matched2 = ISO_REF_NO_YEAR.match item
        matched3 = ISO_REF_ALL_PARTS.match item
        [matched, matched2, matched3]
      end

      def cleanup(xmldoc)
        super
        contributor_cleanup(xmldoc)
        xmldoc
      end

      def contributor_cleanup(xmldoc)
        issuer = xmldoc.at("//bibdata/contributor[role/@type = 'issuer']/organization/name")
        scope = xmldoc.at("//gbscope")&.text
        prefix = xmldoc.at("//gbprefix")&.text
        mandate = xmldoc.at("//gbmandate")&.text || "mandatory"
        agency = issuer.content
        agency = GbConvert.new({}).standard_agency(scope, prefix, mandate) if agency == "GB"
        agency = "GB" unless agency
        owner = xmldoc.at("//copyright/owner/organization/name")
        owner.content = agency
        owner = xmldoc.at("//contributor[role/@type = 'issuer']/organization/name")
        owner.content = agency
        xmldoc.xpath("//gbcommittee").each do |c|
          xmldoc.at("//bibdata/contributor").next = 
            "<contributor><role type='technical-committee'/><organization>"\
            "<name>#{c.text}</name></organization></contributor>"
        end
      end
    end
  end
end
