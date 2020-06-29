module Asciidoctor
  module Gb
    class Converter < ISO::Converter
      def termdef_cleanup(xmldoc)
        super
        # TODO this should become variant tag
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

      def text_clean(text)
        text.gsub(/^\s*/, "").gsub(/</, "&lt;").gsub(/>/, "&gt;")
      end

      def duplicate_localisedstrings(zh)
        en = zh.dup.remove
        zh.after(en).after(" ")
        zh["language"] = "zh"
        en["language"] = "en"
        en.traverse do |c|
          c.text? && c.content = text_clean(c.text.gsub(HAN_TEXT, ""))
        end
        zh.traverse do |c|
          c.text? && c.content = text_clean(c.text.gsub(ROMAN_TEXT, ""))
        end
      end

      def termdef_boilerplate_cleanup(xmldoc)
        return if @keepboilerplate
        super
      end

      def cleanup(xmldoc)
        lang = xmldoc.at("//language")&.text
        @agencyclass = GbAgencies::Agencies.new(lang, {}, "")
        super
        contributor_cleanup(xmldoc)
        xmldoc
      end

      def docidentifier_cleanup(xmldoc)
        id = xmldoc.at("//bibdata/docidentifier[@type = 'gb']") or return
        scope = xmldoc.at("//gbscope")&.text
        prefix = xmldoc.at("//gbprefix")&.text
        mand = xmldoc.at("//gbmandate")&.text || "mandatory"
        idtext = @agencyclass.docidentifier(scope, prefix, mand, nil, id.text)
        id.content = idtext&.gsub(/\&#x2002;/, " ")
        id = xmldoc.at("//bibdata/ext/structuredidentifier/"\
                       "project-number") or return
        idtext = @agencyclass.docidentifier(scope, prefix, mand, nil, id.text)
        id.content = idtext&.gsub(/\&#x2002;/, " ")
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

      def omit_docid_prefix(prefix)
        IsoDoc::Gb::HtmlConvert.new({}).omit_docid_prefix(prefix)
      end

      def boilerplate_cleanup(xmldoc)
        isodoc = boilerplate_isodoc(xmldoc)
        initial_boilerplate(xmldoc, isodoc)
        return if @keepboilerplate
        xmldoc.xpath(self.class::TERM_CLAUSE).each do |f|
          term_defs_boilerplate(f.at("./title"),
                                xmldoc.xpath(".//termdocsource"),
                                f.at(".//term"), f.at(".//p"), isodoc)
        end
        f = xmldoc.at(self.class::NORM_REF) and
          norm_ref_preface(f)
      end
    end
  end
end
