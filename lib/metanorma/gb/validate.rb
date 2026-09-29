require "gb_agencies"

module Metanorma
  module Gb
    class Validate < Iso::Validate
      # The old RNG pass is retired with the model-based pipeline (the
      # iso-main pattern): gbstandard.rng predates the current semantic
      # model, and gb ships no generated compile schema.
      def validate(doc)
        @log.add_error_ranges(doc)
        content_validate(doc)
      end

      def content_validate(doc)
        @agencyclass ||=
          GbAgencies::Agencies.new(doc.at("//language")&.text, {}, "")
        super
        bilingual_terms_validate(doc.root)
        issuer_validate(doc.root)
        prefix_validate(doc.root)
        bibdata_validate(doc.root)
        @agencyclass.gbtype_validate(doc.root.at("//gbscope")&.text, doc.root.at("//gbprefix")&.text)
      end

      # ISO Layer-3 model rules target the ISO root and have no GB
      # profile; the RNG pass went with them.
      def model_validate(_doc); end

      def bibdata_validate(doc)
        doctype_validate(doc)
        script_validate(doc)
      end

      def doctype_validate(xmldoc)
        doctype = xmldoc&.at("//bibdata/ext/doctype")&.text
        %w(standard recommendation).include? doctype or
          @log.add(:GB_5, nil, params: [doctype])
      end

      def script_validate(xmldoc)
        script = xmldoc&.at("//bibdata/script")&.text
        %(Hans Latn).include?(script) or
          @log.add(:GB_6, nil, params: [script])
      end

      def prefix_validate(root)
        prefix = root&.at("//gbprefix")&.text
        scope = root&.at("//gbscope")&.text
        case scope
        when "social-group"
          /^[A-Za-z]{3,6}$/.match(prefix) or
            @log.add(:GB_7, nil, params: [prefix])
        when "enterprise"
          /^[A-Z0-9]{3,}$/.match(prefix) or
            @log.add(:GB_8, nil, params: [prefix])
        when "sector"
          %w(AQ BB CB CH CJ CY DA DB DL DZ EJ FZ GA GH GM GY HB HG HJ HS HY
             JB JC JG JR JT JY LB LD LS LY MH MT MZ NY QB QC QJ QX SB SC SH
             SJ SL SN SY TB TD TJ TY WB WH WJ WM WS WW XB YB YC YD YS YY YZ
             ZY).include? prefix or
             @log.add(:GB_9, nil, params: [prefix])
        when "local"
          %w(11 12 13 14 15 21 22 23 31 32 33 34 35 36 37 41 42 43 44 45 46
             50 51 52 53 54 61 62 63 64 65 71 81 82 end).include? prefix or
             @log.add(:GB_10, nil, params: [prefix])
        when "national"
          %w(GB GBZ GJB GBn GHZB GWPB JJF JJG).include? prefix or
            @log.add(:GB_11, nil, params: [prefix])
        end
      end

      def issuer_validate(root)
        issuer = root&.at("//bibdata/contributor[role/@type = 'issuer']/"\
                          "organization/name")&.text
        scope = root&.at("//gbscope")&.text
        if %w(enterprise social).include?(scope) && issuer == "GB"
          @log.add(:GB_12, nil, params: [scope])
        end
      end

      def check_bilingual(t, element)
        zh = t.at(".//#{element}[@language = 'zh']")
        en = t.at(".//#{element}[@language = 'en']")
        (en.nil? || en.text.empty?) && !(zh.nil? || zh.text.empty?) &&
          @log.add(:GB_13, t, params: [element, zh.text])
        !(en.nil? || en.text.empty?) && (zh.nil? || zh.text.empty?) &&
          @log.add(:GB_14, t, params: [element, en.text])
      end

      def bilingual_terms_validate(root)
        root.xpath("//term").each do |t|
          check_bilingual(t, "preferred")
          check_bilingual(t, "admitted")
          check_bilingual(t, "deprecates")
        end
      end

      def title_intro_validate(root)
        title_intro_en = root.at("//title[@type='title-intro' and @language='en']")
        title_intro_zh = root.at("//title[@type='title-intro' and @language='zh']")
        if title_intro_en.nil? && !title_intro_zh.nil?
          @log.add(:GB_15, title_intro_zh)
        end
        if !title_intro_en.nil? && title_intro_zh.nil?
          @log.add(:GB_16, title_intro_en)
        end
      end

      def title_main_validate(root)
        title_main_en = root.at("//title[@type='title-main' and @language='en']")
        title_main_zh = root.at("//title[@type='title-main' and @language='zh']")
        if title_main_en.nil? && !title_main_zh.nil?
          @log.add(:GB_17, title_main_zh)
        end
        if !title_main_en.nil? && title_main_zh.nil?
          @log.add(:GB_18, title_main_en)
        end
      end

      def title_part_validate(root)
        title_part_en = root.at("//title[@type='title-part' and @language='en']")
        title_part_zh = root.at("//title[@type='title-part' and @language='zh']")
        if title_part_en.nil? && !title_part_zh.nil?
          @log.add(:GB_19, title_part_en)
        end
        if !title_part_en.nil? && title_part_zh.nil?
          @log.add(:GB_20, title_part_zh)
        end
      end
    end
  end
end
