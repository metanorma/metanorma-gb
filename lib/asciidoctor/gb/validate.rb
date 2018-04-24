module Asciidoctor
  module Gb
    class Converter < ISO::Converter

      def validate(doc)
        content_validate(doc)
        schema_validate(formattedstr_strip(doc.dup),
                        File.join(File.dirname(__FILE__), "gbstandard.rng"))
      end

      def content_validate(doc)
        super
        bilingual_terms_validate(doc.root)
        issuer_validate(doc.root)
        prefix_validate(doc.root)
        doc_converter(nil).gbtype_validate(doc.root)
      end

      def prefix_validate(root)
        prefix = root&.at("//gbprefix")&.text
        scope = root&.at("//gbscope")&.text
        case scope
        when "social"
          /^[A-Za-z]{3}$/.match? prefix or
            warn("#{prefix} is improperly formatted for social standards")
        when "enterprise"
          /^[A-Z0-9]{3,}$/.match? prefix or
            warn("#{prefix} is improperly formatted for enterprise standards")
        when "sector"
          %w(AQ BB CB CH CJ CY DA DB DL DZ EJ FZ GA GH GM GY HB HG HJ HS HY
             JB JC JG JR JT JY LB LD LS LY MH MT MZ NY QB QC QJ QX SB SC SH
             SJ SL SN SY TB TD TJ TY WB WH WJ WM WS WW XB YB YC YD YS YY YZ
             ZY).include? prefix or
             warn("#{prefix} is not a legal sector standard prefix")
        when "local"
          %w(11 12 13 14 15 21 22 23 31 32 33 34 35 36 37 41 42 43 44 45 46
             50 51 52 53 54 61 62 63 64 65 71 81 82 end).include? prefix or
             warn("#{prefix} is not a legal local standard prefix")
        when "national"
          %w(GB GBZ GJB GBn GHZB GWPB JJF JJG).include? prefix or
            warn("#{prefix} is not a legal national standard prefix")
        end
      end

      def issuer_validate(root)
        issuer = root&.at("//bibdata/contributor[role/@type = 'issuer']/"\
                          "organization/name")&.text
        scope = root&.at("//gbscope")&.text
        if %w(enterprise social).include?(scope) && issuer == "GB"
          warn "No issuer provided for #{scope} standard"
        end
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

      def norm_bibitem_style(root)
        root.xpath(NORM_BIBITEMS).each do |b|
          if b.at(Asciidoctor::ISO::Cleanup::ISO_PUBLISHER_XPATH).nil?
            unless /^#{GBCODE}(?![A-Z])/.match? b.at("./docidentifier").text
              Asciidoctor::ISO::Utils::warning(b, NORM_ISO_WARN, b.text)
            end
          end
        end
      end
    end
  end
end
