require "isodoc"
require "twitter_cldr"

module Asciidoctor
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class GbConvert < IsoDoc::Convert
      def init_metadata
        super
        set_metadata(:docmaintitlezh, "")
        set_metadata(:docsubtitlezh, "XXXX")
        set_metadata(:docparttitlezh, "")
        set_metadata(:docmaintitleen, "")
        set_metadata(:docsubtitleen, "XXXX")
        set_metadata(:docparttitleen, "")
        set_metadata(:gbequivalence, "")
        set_metadata(:isostandard, nil)
        set_metadata(:isostandardtitle, "")
        set_metadata(:doctitle, "XXXX")
        set_metadata(:obsoletes, nil)
        set_metadata(:obsoletes_part, nil)
      end

      def title(isoxml, _out)
        intro = isoxml.at(ns("//title-intro[@language='zh']"))
        main = isoxml.at(ns("//title-main[@language='zh']"))
        part = isoxml.at(ns("//title-part[@language='zh']"))
        partnumber = isoxml.at(ns("//project-number/@part"))
        intro.nil? || set_metadata(:docmaintitlezh, intro.text + "&mdash;")
        main.nil? || set_metadata(:docsubtitlezh, main.text)
        partnum = partnumber ? "#{part_label(partnumber, 'zh')}: " : ""
        part.nil? || set_metadata(:docparttitlezh,
                                  "&mdash;#{partnum} #{part.text}")
        set_metadata(:doctitle, get_metadata[:docmaintitlezh] + 
                     get_metadata[:docsubtitlezh] +
                     get_metadata[:docparttitlezh])
      end

      def subtitle(isoxml, _out)
        intro = isoxml.at(ns("//title-intro[@language='en']"))
        main = isoxml.at(ns("//title-main[@language='en']"))
        part = isoxml.at(ns("//title-part[@language='en']"))
        partnumber = isoxml.at(ns("//project-number/@part"))
        intro.nil? || set_metadata(:docmaintitleen, intro.text + "&mdash;")
        main.nil? || set_metadata(:docsubtitleen, main.text)
        partnum = partnumber ? "#{part_label(partnumber, 'en')}: " : ""
        part.nil? || set_metadata(:docparttitleen,
                                  "&mdash;#{partnum} #{part.text}")
      end

      def author(isoxml, _out)
        gbcommittee = isoxml.at(ns("//bibdata/gbcommittee"))
        set_metadata(:committee, gbcommittee.text)
      end

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

      def stage_abbrev_cn(stage, iter, draft)
        stage = STAGE_ABBRS_CN[stage.to_sym] || "??"
        stage = "#{iter.text.to_i.localize(:zh).spellout}次#{stage}" if iter
        stage = "Pre" + stage if draft&.text =~ /^0\./
        stage
      end

      def docstatus(isoxml, _out)
        docstatus = isoxml.at(ns("//status/stage"))
        if docstatus
          set_metadata(:stage, docstatus.text)
          abbr = stage_abbrev_cn(docstatus.text, isoxml.at(ns("//status/iteration")),
                              isoxml.at(ns("//version/draft")))
          set_metadata(:stageabbr, abbr)
        end
      end

      def docid1(isoxml, _out)
        dn = docnumber(isoxml)
        docstatus = get_metadata[:stage]
        if docstatus
          abbr = stage_abbrev(docstatus, isoxml.at(ns("//status/iteration")),
                            isoxml.at(ns("//version/draft")))
          (docstatus.to_i < 60) && dn = abbr + " " + dn
        end
        set_metadata(:docnumber, dn)
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
        set_metadata(:isostandard, isostdid.text)
        isostdtitle = isoxml.at(ns("#{ISO_STD_XPATH}/title"))
        set_metadata(:isostandardtitle, isostdtitle.text) if isostdtitle
        eq = isoxml.at(ns("//bibdata/relation/@type"))
        case eq.text
        when "equivalent" then set_metadata(:gbequivalence, "MOD")
        when "nonequivalent" then set_metadata(:gbequivalence, "NEQ")
        when "identical" then set_metadata(:gbequivalence, "IDT")
        end
      end

      def docidentifier(gbscope, gbprefix, gbmandate)
        docnum = get_metadata[:docnumber]
        dn = if gbscope == "local"
               "DB#{mandate_suffix(gbprefix, gbmandate)}/#{docnum}".
                 gsub(%r{/([TZ])/}, "/\\1 ")
             else
               "#{mandate_suffix(gbprefix, gbmandate)} #{docnum}"
             end
        set_metadata(:docidentifier, dn)
      end

      def gb_identifier(isoxml)
        scope = isoxml.at(ns("//gbscope"))&.text || "national"
        mandate = isoxml.at(ns("//gbmandate"))&.text || "mandatory"
        prefix = isoxml.at(ns("//gbprefix"))&.text || "XXX"
        docidentifier(scope, prefix, mandate)
        set_metadata(:standard_class, standard_class(scope, prefix, mandate))
        set_metadata(:standard_agency, standard_agency(scope, prefix, mandate))
        set_metadata(:gbprefix, scope == "local" ? "DB" : prefix)
        set_metadata(:gbscope, scope)
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
        isoxml.xpath(ns("//bibdata/ics")).each { |i| ics << i.text }
        isoxml.xpath(ns("//bibdata/ccs")).each { |i| ccs << i.text }
        p = isoxml.at(ns("//bibdata/plannumber"))
        set_metadata(:libraryid_ics, ics.empty? ? "XXX" : ics.join(", "))
        set_metadata(:libraryid_ccs, ccs.empty? ? "XXX" : ccs.join(", "))
        set_metadata(:libraryid_plan, p ? p.text : "XXX")
      end

      def part_label(partnumber, lang)
        case lang
        when "en" then "Part #{partnumber}"
        when "zh" then "第#{partnumber}部"
        end
      end
    end
  end
end
