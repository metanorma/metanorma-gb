module Asciidoctor
  module Gb
    class Converter < ISO::Converter
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

      def stage_name(stage, substage)
        return "Proof" if stage == "60" && substage == "00"
        @lang == "en" ?
          STAGE_NAMES[stage.to_sym] : STAGE_ABBRS_CN[stage.to_sym]
      end

      def iso_id(node, xml)
        return unless node.attr("docnumber")
        part = node.attr("partnumber")
        dn = add_id_parts(node.attr("docnumber"), part, nil)
        dn = id_stage_prefix(dn, node)
        xml.docidentifier dn, **attr_code(type: "gb")
      end

      def structured_id(node, xml)
        part = node.attr("partnumber")
        xml.structuredidentifier do |i|
          i.project_number node.attr("docnumber"),
            **attr_code(part: part)
        end
      end

      def add_id_parts(dn, part, subpart)
        dn += ".#{part}" if part
        dn += ".#{subpart}" if subpart
        dn
      end

      def id_stage_prefix(dn, node)
        if node.attr("docstage") && node.attr("docstage").to_i < 60
          abbr = IsoDoc::Gb::Metadata.new("en", "Latn", @i18n).
            status_abbrev(node.attr("docstage"), nil, node.attr("iteration"),
                          node.attr("draft"), node.attr("doctype"))
          dn = "/#{abbr} #{dn}" # prefixes added in cleanup
        else
          dn += "-#{node.attr("copyright-year")}" if node.attr("copyright-year")
        end
        dn
      end
    end
  end
end
