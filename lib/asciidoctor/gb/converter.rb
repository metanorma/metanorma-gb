require "asciidoctor"
require "asciidoctor/iso/converter"
require "asciidoctor/gb/version"
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
        node.nil? ? IsoDoc::Gb::Convert.new({}) :
          IsoDoc::Gb::Convert.new(
            script: node.attr("script"),
            bodyfont: node.attr("body-font"),
            headerfont: node.attr("header-font"),
            monospacefont: node.attr("monospace-font"),
            titlefont: node.attr("title-font"),
            i18nyaml: node.attr("i18nyaml"),
            scope: node.attr("scope"),
        )
      end

      def doc_converter(node)
        node.nil? ? IsoDoc::Gb::WordConvert.new({}) :
        IsoDoc::Gb::WordConvert.new(
          script: node.attr("script"),
          bodyfont: node.attr("body-font"),
          headerfont: node.attr("header-font"),
          monospacefont: node.attr("monospace-font"),
          titlefont: node.attr("title-font"),
          i18nyaml: node.attr("i18nyaml"),
          scope: node.attr("scope"),
        )
      end

      def default_fonts(node)
        script = node.attr("script") || "Hans"
        b = node.attr("body-font") ||
          (script == "Hans" ? '"SimSun",serif' :
           script == "Latn" ? '"Cambria",serif' : '"SimSun",serif' )
        h = node.attr("header-font") ||
          (script == "Hans" ? '"SimHei",sans-serif' :
           script == "Latn" ? '"Calibri",sans-serif' : '"SimHei",sans-serif' )
        m = node.attr("monospace-font") || '"Courier New",monospace'
        scope = node.attr("scope") || "national"
        t = node.attr("title-font") ||
          (scope == "national" ? (script != "Hans" ? '"Cambria",serif' : '"SimSun",serif' ) :
           (script == "Hans" ? '"SimHei",sans-serif' : '"Calibri",sans-serif' ))
        "$bodyfont: #{b};\n$headerfont: #{h};\n$monospacefont: #{m};\n$titlefont: #{t};\n"
      end

      def document(node)
        init(node)
        ret = makexml(node).to_xml(indent: 2)
        filename = node.attr("docfile").gsub(/\.adoc$/, "").gsub(%r{^.*/}, "")
        File.open(filename, "w") { |f| f.write(ret) }
        unless node.attr("nodoc")
          #html_converter_alt(node).convert(filename + ".xml")
          #system "mv #{filename}.html #{filename}_alt.html"
          html_converter(node).convert(filename + ".xml")
          doc_converter(node).convert(filename + ".xml")
        end
        @files_to_delete.each { |f| system "rm #{f}" }
        ret
      end

      def termdef_cleanup(xmldoc)
        super
        localisedstr(xmldoc)
      end

      ROMAN_TEXT = /\s*[a-z\u00c0-\u00d6\u00d8-\u00f0\u0100-\u0240]/i
      HAN_TEXT = /\s*[\u4e00-\u9fff]+/

      LOCALISED_ELEMS = "//admitted | //deprecates | //preferred | //prefix | "\
        "//initial | //addition | //surname | //forename | //name | "\
        "//abbreviation | //role/description | //affiliation/description | "\
        "//bibdata/item | //bibitem/title | //bibdata/formattedref | "\
        "//bibitem/formattedref | //bibdata/note | //bibitem/note | "\
        "//bibdata/abstract | //bibitem/note ".freeze

      MUST_LOCALISE_ELEMS = %w{admitted deprecates preferred}.freeze

      def localisedstr(xmldoc)
        xmldoc.xpath(LOCALISED_ELEMS).each do |zh|
          if zh.at("./string")
            extract_localisedstrings(zh)
          elsif MUST_LOCALISE_ELEMS.include? zh.name
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

      def termdef_boilerplate_cleanup(xmldoc)
        nil
      end

      GBCODE = "((AQ|BB|CB|CH|CJ|CY|DA|DB|DL|DZ|EJ|FZ|GA|GH|GM|GY|HB|HG|"\
        "HJ|HS|HY|JB|JC|JG|JR|JT|JY|LB|LD|LS|LY|MH|MT|MZ|NY|QB|QC|QJ|"\
        "QZ|SB|SC|SH|SJ|SN|SY|TB|TD|TJ|TY|WB|WH|WJ|WM|WS|WW|XB|YB|YC|"\
        "YD|YS|YY|YZ|ZY|GB|GBZ|GJB|GBn|GHZB|GWKB|GWPB|JJF|JJG|Q|T)(/Z|/T)?)"

      ISO_REF = %r{^<ref\sid="(?<anchor>[^"]+)">
      \[(?<code>(ISO|IEC|#{GBCODE})[^0-9]*\s[0-9-]+)(:(?<year>[0-9]+))?\]</ref>,?\s
      (?<text>.*)$}xm

      ISO_REF_NO_YEAR = %r{^<ref\sid="(?<anchor>[^"]+)">
      \[(?<code>(ISO|IEC|#{GBCODE})[^0-9]*\s[0-9-]+):--\]</ref>,?\s?
      <fn[^>]*>\s*<p>(?<fn>[^\]]+)</p>\s*</fn>,?\s?(?<text>.*)$}xm

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
        lang = xmldoc.at("//language")&.text
        agency = issuer.content
        agency = IsoDoc::Gb::Convert.new({}).standard_agency1(scope, prefix, mandate) if agency == "GB"
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
