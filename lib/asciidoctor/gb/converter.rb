require "asciidoctor"
require "asciidoctor/iso/converter"
require "asciidoctor/gb/version"
require "isodoc/gb/gbconvert"
require "isodoc/gb/gbwordconvert"
require "gb_agencies"
require_relative "./section_input.rb"
require_relative "./front.rb"
require_relative "./validate.rb"

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
        @keepboilerplate = node.attributes.has_key?("keep-boilerplate")
        result << noko { |ixml| front node, ixml }
        result << noko { |ixml| middle node, ixml }
        result << "</gb-standard>"
        result = textcleanup(result.flatten * "\n")
        ret1 = cleanup(Nokogiri::XML(result))
        validate(ret1)
        ret1.root.add_namespace(nil, GB_NAMESPACE)
        ret1
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

      def document(node)
        init(node)
        ret = makexml(node).to_xml(indent: 2)
        unless node.attr("nodoc") || !node.attr("docfile")
          filename = node.attr("docfile").gsub(/\.adoc$/, "").gsub(%r{^.*/}, "")
          File.open(filename + ".xml", "w") { |f| f.write(ret) }
          html_compliant_converter(node).convert(filename + ".xml")
          system "mv #{filename}.html #{filename}_compliant.html"
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
        return if @keepboilerplate
        super
      end

      GBCODE = "((AQ|BB|CB|CH|CJ|CY|DA|DB|DL|DZ|EJ|FZ|GA|GH|GM|GY|HB|HG|"\
        "HJ|HS|HY|JB|JC|JG|JR|JT|JY|LB|LD|LS|LY|MH|MT|MZ|NY|QB|QC|QJ|"\
        "QZ|SB|SC|SH|SJ|SN|SY|TB|TD|TJ|TY|WB|WH|WJ|WM|WS|WW|XB|YB|YC|"\
        "YD|YS|YY|YZ|ZY|GB|GBZ|GJB|GBn|GHZB|GWKB|GWPB|JJF|JJG|Q|T)(/Z|/T)?)"

      ISO_REF = %r{^<ref\sid="(?<anchor>[^"]+)">
      \[(?<code>(ISO|IEC|#{GBCODE})[^0-9]*\s[0-9-]+?)
      ([:-](?<year>(19|20)[0-9][0-9]))?\]</ref>,?\s
      (?<text>.*)$}xm

      ISO_REF_NO_YEAR = %r{^<ref\sid="(?<anchor>[^"]+)">
      \[(?<code>(ISO|IEC|#{GBCODE})[^0-9]*\s[0-9-]+):--\]</ref>,?\s?
      <fn[^>]*>\s*<p>(?<fn>[^\]]+)</p>\s*</fn>,?\s?(?<text>.*)$}xm

      ISO_REF_ALL_PARTS = %r{^<ref\sid="(?<anchor>[^"]+)">
      \[(?<code>(ISO|IEC|#{GBCODE})[^0-9]*\s[0-9]+)\s
      \(all\sparts\)\]</ref>(<p>)?,?\s?
      (?<text>.*)(</p>)?$}xm

      def reference1_matches(item)
        matched = ISO_REF.match item
        matched2 = ISO_REF_NO_YEAR.match item
        matched3 = ISO_REF_ALL_PARTS.match item
        [matched, matched2, matched3]
      end

      def fetch_ref(xml, code, year, **opts)
        code = "GB Standard " + code if /^#{GBCODE}[^A-Za-z]/.match? code
        hit = @bibdb&.fetch(code, year, opts)
        return nil if hit.nil?
        xml.parent.add_child(hit.to_xml)
        xml
      rescue Algolia::AlgoliaProtocolError
        nil # Render reference without an Internet connection.
      end

      def cleanup(xmldoc)
        lang = xmldoc.at("//language")&.text
        @agencyclass = GbAgencies::Agencies.new(lang, {}, "")
        super
        contributor_cleanup(xmldoc)
        xmldoc
      end

      def docidentifier_cleanup(xmldoc)
        id = xmldoc.at("//bibdata/docidentifier/project-number") or return
        scope = xmldoc.at("//gbscope")&.text
        prefix = xmldoc.at("//gbprefix")&.text
        mandate = xmldoc.at("//gbmandate")&.text || "mandatory"
        idtext = @agencyclass.docidentifier(scope, prefix, mandate,
                                            nil, id.text) || return
        id.content = idtext.gsub(/\&#x2002;/, " ")
      end

      def committee_cleanup(xmldoc)
        xmldoc.xpath("//gbcommittee").each do |c|
          xmldoc.at("//bibdata/contributor").next =
            "<contributor><role type='technical-committee'/><organization>"\
            "<name>#{c.text}</name></organization></contributor>"
        end
      end

      def agency_value(issuer, scope, prefix, mandate)
        agency = issuer.content
        agency == "GB" and
          agency = @agencyclass.standard_agency1(scope, prefix, mandate)
        agency = "GB" if agency.nil? || agency.empty?
        agency
      end

      def contributor_cleanup(xmldoc)
        issuer = xmldoc.at("//bibdata/contributor[role/@type = 'issuer']/"\
                           "organization/name")
        scope = xmldoc.at("//gbscope")&.text
        prefix = xmldoc.at("//gbprefix")&.text
        mandate = xmldoc.at("//gbmandate")&.text || "mandatory"
        agency = agency_value(issuer, scope, prefix, mandate)
        owner = xmldoc.at("//copyright/owner/organization/name")
        owner.content = agency
        issuer.content = agency
        committee_cleanup(xmldoc)
      end
    end
  end
end
