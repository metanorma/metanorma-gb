require "isodoc"

module Asciidoctor
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class GbConvert < IsoDoc::Convert
      def init_metadata
        super
        set_metadata(:docmaintitlezh, "XXXX")
        set_metadata(:docsubtitlezh, "")
        set_metadata(:docparttitlezh, "")
        set_metadata(:docmaintitleen, "XXXX")
        set_metadata(:docsubtitleen, "")
        set_metadata(:docparttitleen, "")
      end

      def title(isoxml, _out)
        intro = isoxml.at(ns("//title-intro[@language='zh']"))
        main = isoxml.at(ns("//title-main[@language='zh']"))
        part = isoxml.at(ns("//title-part[@language='zh']"))
        partnumber = isoxml.at(ns("//project-number/@part"))
        intro.nil? || set_metadata(:docmaintitlezh, intro.text + "&mdash;")
        set_metadata(:docsubtitlezh, main.text)
        partnum = partnumber ? "#{part_label(partnumber, 'zh')}: " : ""
        part.nil? || set_metadata(:docparttitlezh, 
                                  "&mdash;#{partnum} #{part.text}")
      end

      def subtitle(isoxml, _out)
        intro = isoxml.at(ns("//title-intro[@language='en']"))
        main = isoxml.at(ns("//title-main[@language='en']"))
        part = isoxml.at(ns("//title-part[@language='en']"))
        partnumber = isoxml.at(ns("//project-number/@part"))
        intro.nil? || set_metadata(:docmaintitleen, intro.text + "&mdash;")
        set_metadata(:docsubtitleen, main.text)
        partnum = partnumber ? "#{part_label(partnumber, 'en')}: " : ""
        part.nil? || set_metadata(:docparttitleen, 
                                  "&mdash;#{partnum} #{part.text}")
      end

      def author(isoxml, _out)
        gbcommittee = isoxml.at(ns("//bibdata/gbcommittee"))
        set_metadata(:committee, gbcommittee.text)
      end

      def id(isoxml, _out)
        super
        gb_identifier(isoxml)
        gb_library_identifier(isoxml)
      end

      def docidentifier(gbscope, gbprefix, gbmandate)
        docnum = get_metadata()[:docnumber]
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
        docidentifier(gbscope, gbprefix, gbmandate)
        set_metadata(:standard_class, standard_class(scope, prefix, mandate))
        set_metadata(:standard_agency, standard_agency(scope, prefix, mandate))
        set_metadata(:gbprefix, scope == "local" ? "DB" : prefix)
      end

      def standard_logo(gbprefix)
        case gbprefix.downcase
        when "db" then "gb-standard-db"
        when "gb" then "gb-standard-gb"
        when "gjb" then "gb-standard-gjb"
        when "gjb" then "gb-standard-gjb"
        when "gm" then "gb-standard-gm"
        when "jjf" then "gb-standard-jjf"
        when "zb" then "gb-standard-zb"
        else
          nil
        end
      end

      def gb_library_identifier(isoxml)
        ics = isoxml.at(ns("//gblibraryids/ics"))
        l = isoxml.at(ns("//gblibraryids/l"))
        set_metadata(:libraryid_ics, ics ? ics.text : "XXX")
        set_metadata(:libraryid_l, l ? l.text : "XXX")
      end

      def part_label(partnumber, lang)
        case lang
        when "en" then "Part #{partnumber}"
        when "zh" then "第#{partnumber}部"
        end
      end

      def format_logo(prefix, _format)
        logo = standard_logo(prefix)
        if logo.nil?
          "<span style='font-size:36pt;font-weight:bold'>#{prefix}</span>"
        else
          logo += ".gif"
          system "cp #{fileloc(File.join("html/gb-logos", logo))}  #{logo}"
          "<img width='113' height='56' src='#{logo}' alt='#{prefix}'>"
        end
      end

      def format_agency(agency, format)
        if agency.is_a?(Array)
          ret = "<table><tr><td>#{agency[0]}</td><td rowspan='#{agency.size}'>发布</td></tr>"
          agency[1..-1].each { |a| ret += "<tr><td>#{a}</td></tr>" }
          ret += "</table>"
          if format == :word
            ret.gsub!(/<table>/, "<table width='100%'>")
          end
          ret
        else
          agency
        end
      end

      def termref_render(x)
        parts = x.split(%r{(\s*\[MODIFICATION\]|,)}m)        
        parts[1] = "，定义" if parts.size > 1 && parts[1] == ","
        parts.map do |p|
          /\s*\[MODIFICATION\]/.match?(p) ? ", 改写 &mdash; " : p 
        end.join.sub(/\A\s*/m, "【").sub(/\s*\z/m, "】")
      end

      def populate_template(docxml, format)
        meta = get_metadata
        logo = format_logo(meta[:gbprefix], format)
        docxml = docxml.split(%r{(\[TERMREF\]|\[/TERMREF\])}).each_slice(4).
          map do |a|
          a.size < 3 ? a[0] : a[0] + termref_render(a[2])
        end.join

        docxml.
          gsub(/DOCYEAR/, meta[:docyear]).
          gsub(/DOCNUMBER/, meta[:docnumber]).
          gsub(/DOCIDENTIFIER/, meta[:docidentifier]).
          gsub(/COMMITTEE/, meta[:committee]).
          gsub(/DOCMAINTITLEZH/, meta[:docmaintitlezh]).
          gsub(/DOCSUBTITLEZH/, meta[:docsubtitlezh]).
          gsub(/DOCPARTTITLEZH/, meta[:docparttitlezh]).
          gsub(/DOCMAINTITLEEN/, meta[:docmaintitleen]).
          gsub(/DOCSUBTITLEEN/, meta[:docsubtitleen]).
          gsub(/DOCPARTTITLEEN/, meta[:docparttitleen]).
          gsub(/PUBDATE/, meta[:publisheddate]).
          gsub(/ACTIVEDATE/, meta[:activateddate]).
          gsub(/LIBRARYID_ICS/, meta[:libraryid_ics]).
          gsub(/LIBRARYID_L/, meta[:libraryid_l]).
          gsub(/STANDARD_CLASS/, meta[:standard_class]).
          gsub(/STANDARD_AGENCY/, 
               format_agency(meta[:standard_agency], format)).
        gsub(/STANDARD_LOGO/, logo).
        gsub(/[ ]?DRAFTINFO/, meta[:draftinfo]).
        gsub(/\s*\[ISOSECTION\]/, ", 定义").
        gsub(%r{WD/CD/DIS/FDIS}, meta[:stageabbr])
      end

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
    end
  end
end
