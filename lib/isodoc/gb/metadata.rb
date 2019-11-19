require "isodoc"
require "twitter_cldr"
require "htmlentities"

module IsoDoc
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class Metadata < IsoDoc::Metadata
      def initialize(lang, script, labels)
        super
        set(:docmaintitlezh, "")
        set(:docsubtitlezh, "XXXX")
        set(:docparttitlezh, "")
        set(:docmaintitleen, "")
        set(:docsubtitleen, "XXXX")
        set(:docparttitleen, "")
        set(:gbequivalence, "")
        set(:isostandard, nil)
        set(:isostandardtitle, "")
        set(:doctitle, "XXXX")
        set(:obsoletes, nil)
        set(:obsoletes_part, nil)
      end

      def title(isoxml, _out)
        intro = isoxml.at(ns("//bibdata//title[@type='title-intro' and @language='zh']"))
        main = isoxml.at(ns("//bibdata//title[@type='title-main' and @language='zh']"))
        part = isoxml.at(ns("//bibdata//title[@type='title-part' and @language='zh']"))
        partnumber = isoxml.at(ns("//bibdata/ext/structuredidentifier/project-number/@part"))
        intro.nil? || set(:docmaintitlezh, intro.text + "&nbsp;")
        main.nil? || set(:docsubtitlezh, main.text)
        partnum = partnumber ? "#{part_label(partnumber, 'zh')}:" : ""
        part.nil? || set(:docparttitlezh,
                                  "&nbsp;#{partnum}#{part.text}")
      end

      def set_doctitle
        if @lang == "zh"
          set(:doctitle, get[:docmaintitlezh] + 
                       get[:docsubtitlezh] + get[:docparttitlezh])
        else
          set(:doctitle, get[:docmaintitleen] + 
                       get[:docsubtitleen] + get[:docparttitleen])
        end
      end

      def subtitle(isoxml, _out)
        intro = isoxml.at(ns("//bibdata//title[@type='title-intro' and @language='en']"))
        main = isoxml.at(ns("//bibdata//title[@type='title-main' and @language='en']"))
        part = isoxml.at(ns("//bibdata//title[@type='title-part' and @language='en']"))
        partnumber = isoxml.at(ns("//bibdata/ext/structuredidentifier/project-number/@part"))
        intro.nil? || set(:docmaintitleen, intro.text + "&mdash;")
        main.nil? || set(:docsubtitleen, main.text)
        partnum = partnumber ? "#{part_label(partnumber, 'en')}: " : ""
        part.nil? || set(:docparttitleen,
                                  "&mdash;#{partnum} #{part.text}")
        set_doctitle
      end

      def author(isoxml, _out)
        gbcommittee = isoxml.at(ns("//bibdata/ext/gbcommittee"))
        set(:committee, gbcommittee&.text)
      end

      # from ISO
      STAGE_ABBRS = {
        "00": "PWI",
        "10": "NWIP",
        "20": "WD",
        "30": "CD",
        "40": "DIS",
        "50": "FDIS",
        "60": "IS",
        "90": "(Review)",
        "95": "(Withdrawal)",
      }.freeze

      STAGE_ABBRS_CN = {
        "00": "新工作项目建议",
        "10": "新工作项目",
        "20": "标准草案工作组讨论稿",
        "30": "标准草案征求意见稿",
        "40": "标准草案送审稿",
        "50": "标准草案报批稿",
        "60": "国家标准",
        "90": "(Review)",
        "95": "(Withdrawal)",
      }.freeze

      STATUS_CSS = {
        "00": "working-draft",
        "10": "working-draft",
        "20": "working-draft",
        "30": "committee-draft",
        "40": "draft-standard",
        "50": "draft-standard",
        "60": "standard",
        "90": "standard",
        "95": "obsolete",
      }

      def stage_abbrev(stage, iter, draft)
        stage = STAGE_ABBRS[stage.to_sym] || "??"
        stage += iter if iter
        stage = "Pre" + stage if draft =~ /^0\./
        stage
      end

      def stage_abbrev_cn(stage, iter, draft)
        return stage_abbrev(stage, iter, draft) if @lang != "zh"
        stage = STAGE_ABBRS_CN[stage.to_sym] || "??"
        stage = "#{iter.to_i.localize(:zh).spellout.force_encoding("UTF-8")}次#{stage}" if iter
        stage = "Pre" + HTMLEntities.new.encode(stage, :hexadecimal) if draft =~ /^0\./
        stage
      end

      def docstatus(isoxml, _out)
        docstatus = isoxml.at(ns("//bibdata/status/stage"))
        set(:unpublished, false)
        if docstatus
          set(:stage, docstatus.text.to_i)
          set(:unpublished, docstatus.text.to_i < 60)
          abbr = stage_abbrev_cn(docstatus.text,
                                 isoxml&.at(ns("//bibdata/status/iteration"))&.text,
                                 isoxml&.at(ns("//version/draft"))&.text)
          set(:stageabbr, abbr)
          set(:status, STATUS_CSS[docstatus.text.to_sym])
        end
      end

      def docid1(isoxml, _out)
        dn = isoxml.at(ns("//bibdata/docidentifier[@type = 'gb']"))
        set(:docnumber, dn&.text)
      end

      def docid(isoxml, _out)
        docid1(isoxml, _out)
        gb_identifier(isoxml)
        gb_library_identifier(isoxml)
        gb_equivalence(isoxml)
      end

      ISO_STD_XPATH = "//bibdata/relation[@type = 'equivalent' or "\
        "@type = 'identical' or @type = 'nonequivalent']/bibitem".freeze

      def gb_equivalence(isoxml)
        isostdid = isoxml.at(ns("#{ISO_STD_XPATH}/docidentifier")) || return
        set(:isostandard, isostdid.text)
        isostdtitle = isoxml.at(ns("#{ISO_STD_XPATH}/title"))
        set(:isostandardtitle, isostdtitle.text) if isostdtitle
        eq = isoxml.at(ns("//bibdata/relation/@type"))
        case eq.text
        when "equivalent" then set(:gbequivalence, "MOD")
        when "nonequivalent" then set(:gbequivalence, "NEQ")
        when "identical" then set(:gbequivalence, "IDT")
        end
      end

      def standard_class(scope, prefix, mandate)
        standardclassimg = get[:standardclassimg]
        ret = @agencies.standard_class(scope, prefix, mandate)
        return "<img class='logo' src='#{standardclassimg}' alt='#{ret}'></img>" if standardclassimg
        ret
      end

      def gb_identifier(isoxml)
        scope = isoxml.at(ns("//bibdata/ext/gbtype/gbscope"))&.text || "national"
        mandate = isoxml.at(ns("//bibdata/ext/gbtype/gbmandate"))&.text || "mandatory"
        prefix = isoxml.at(ns("//bibdata/ext/gbtype/gbprefix"))&.text || "XXX"
        docyear = isoxml&.at(ns("//bibdata/copyright/from"))&.text
        issuer = isoxml&.at(ns("//bibdata/contributor[role/@type = 'issuer']/"\
                               "organization/name"))&.text || "GB"
        @agencies = GbAgencies::Agencies.new(@lang, @labels, issuer)
        set(:docidentifier, get[:docnumber])
        set(:issuer, issuer)
        set(:standard_class, standard_class(scope, prefix, mandate))
        set(:standard_agency, @agencies.standard_agency(scope, prefix, mandate))
        if scope == "local"
          set(:gbprefix, "DB")
          set(:gblocalcode, prefix)
        else
          set(:gbprefix, prefix)
        end 
        set(:gbscope, scope)
      end

      def standard_logo(gbprefix)
        return nil unless gbprefix
        case gbprefix.downcase
        when "db" then "gb-standard-db"
        when "gb" then "gb-standard-gb"
        when "gjb" then "gb-standard-gjb"
        when "gm" then "gb-standard-gm"
        when "jjf" then "gb-standard-jjf"
        when "zb" then "gb-standard-zb"
        end
      end

      def gb_library_identifier(isoxml)
        ics = []
        ccs = []
        isoxml.xpath(ns("//bibdata/ext/ics/code")).each { |i| ics << i.text }
        isoxml.xpath(ns("//bibdata/ext/ccs")).each { |i| ccs << i.text }
        p = isoxml.at(ns("//bibdata/ext/plannumber"))
        set(:libraryid_ics, ics.empty? ? "XXX" : ics.join(", "))
        set(:libraryid_ccs, ccs.empty? ? "XXX" : ccs.join(", "))
        set(:libraryid_plan, p ? p.text : "XXX")
      end

      def part_label(partnumber, lang)
        case lang
        when "en" then "Part #{partnumber}"
        when "zh" then "第#{partnumber}部分"
        end
      end

      def bibdate(isoxml, _out)
        super
        m = get
        if @lang == "zh"
          set(:labelled_publisheddate, m[:publisheddate] + " " +
              @labels["publicationdate_lbl"])
          set(:labelled_implementeddate, m[:implementeddate] + " " +
              @labels["implementationdate_lbl"])
        else
          set(:labelled_publisheddate, @labels["publicationdate_lbl"] +
              ": " + m[:publisheddate])
          set(:labelled_implementeddate,
              @labels["implementationdate_lbl"] + ": " +
              m[:implementeddate])
        end
      end
    end
  end
end
