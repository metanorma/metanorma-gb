require "isodoc"
  
module Asciidoctor
  module Gb
    # A {Converter} implementation that generates CSD output, and a document
    # schema encapsulation of the document for validation
    class GbConvert < IsoDoc::Convert
          def initial_anchor_names(d)
        introduction_names(d.at(ns("//introduction")))
        section_names(d.at(ns("//clause[title = '范围' or title = 'Scope']")), "1", 1)
        section_names(d.at(ns(
          "//references[title = '规范性引用文件' or title = 'Normative References']")), "2", 1)
        section_names(d.at(ns("//terms")), "3", 1)
        middle_section_asset_names(d)
      end

      def middle_section_asset_names(d)
        middle_sections = "//clause[title = '范围' or title = 'Scope'] | "\
          "//references[title = '规范性引用文件' or title = 'Normative References'] | //terms | "\
          "//symbols-abbrevs | //clause[parent::sections]"
        sequential_asset_names(d.xpath(ns(middle_sections)))
      end

      def clause_names(docxml,sect_num)
        q = "//clause[parent::sections][not(xmlns:title = '范围') and not (xmlns:title = 'Scope')]"
        docxml.xpath(ns(q)).each_with_index do |c, i|
          section_names(c, (i + sect_num).to_s, 1)
        end
      end

      def termnote_anchor_names(docxml)
        docxml.xpath(ns("//term[termnote]")).each do |t|
          t.xpath(ns("./termnote")).each_with_index do |n, i|
            @anchors[n["id"]] = { label: "注 #{i + 1}",
                                  xref: "#{@anchors[t["id"]][:xref]},"\
                                  "注 #{i + 1}" }
          end
        end
      end

      def table_note_anchor_names(docxml)
        docxml.xpath(ns("//table[note]")).each do |t|
          t.xpath(ns("./note")).each_with_index do |n, i|
            @anchors[n["id"]] = { label: "注 #{i + 1}",
                                  xref: "#{@anchors[t["id"]][:xref]},"\
                                  "注 #{i + 1}" }
          end
        end
      end

      def sequential_figure_names(clause)
        i = j = 0
        clause.xpath(ns(".//figure")).each do |t|
          label = "图 #{i}" + ( j.zero? ? "" : "-#{j}" )
          if t.parent.name == "figure"
            j += 1
          else
            j = 0
            i += 1
          end
          label = "图 #{i}" + ( j.zero? ? "" : "-#{j}" )
          @anchors[t["id"]] = { label: label, xref: label }
        end
      end

      def sequential_asset_names(clause)
        clause.xpath(ns(".//table")).each_with_index do |t, i|
          @anchors[t["id"]] = { label: "表 #{i + 1}",
                                xref: "表 #{i + 1}" }
        end
        sequential_figure_names(clause)
        clause.xpath(ns(".//formula")).each_with_index do |t, i|
          @anchors[t["id"]] = { label: (i + 1).to_s,
                                xref: "公式 #{i + 1}" }
        end
      end

      def hierarchical_figure_names(clause, num)
        i = j = 0
        clause.xpath(ns(".//figure")).each do |t|
          if t.parent.name == "figure"
            j += 1
          else
            j = 0
            i += 1
          end
          label = "图 #{num}.#{i}" + ( j.zero? ? "" : "-#{j}" )
          @anchors[t["id"]] = { label: label, xref: label }
        end
      end

      def hierarchical_asset_names(clause, num)
        clause.xpath(ns(".//table")).each_with_index do |t, i|
          @anchors[t["id"]] = { label: "表 #{num}.#{i + 1}",
                                xref: "表 #{num}.#{i + 1}" }
        end
        hierarchical_figure_names(clause, num)
        clause.xpath(ns(".//formula")).each_with_index do |t, i|
          @anchors[t["id"]] = { label: "#{num}.#{i + 1}",
                                xref: "公式 #{num}.#{i + 1}" }
        end
      end

      def section_names(clause, num, level)
        @anchors[clause["id"]] = { label: num, xref: "#{num}",
                                   level: level }
        clause.xpath(ns("./subsection | ./term")).each_with_index do |c, i|
          section_names1(c, "#{num}.#{i + 1}", level + 1)
        end
      end

      def section_names1(clause, num, level)
        @anchors[clause["id"]] =
          { label: num, level: level,
            xref: clause.name == "term" ? num : "#{num}" }
        clause.xpath(ns("./subsection ")).
          each_with_index do |c, i|
          section_names1(c, "#{num}.#{i + 1}", level + 1)
        end
      end

      def annex_names(clause, num)
        obligation = "（非规范性）"
        obligation = "（规范性）" if clause["subtype"] == "normative"
        label = "<b>附录 #{num}</b><br/>#{obligation}"
        @anchors[clause["id"]] = { label: label,
                                   xref: "附录 #{num}", level: 1 }
        clause.xpath(ns("./subsection")).each_with_index do |c, i|
          annex_names1(c, "#{num}.#{i + 1}", 2)
        end
        hierarchical_asset_names(clause, num)
      end

      def format_ref(ref, isopub)
        return "ISO #{ref}" if isopub
        return "[#{ref}]" if /^\d+$/.match?(ref) && !/^\[.*\]$/.match?(ref)
        ref
      end

      def reference_names(ref)
        isopub = ref.at(ns(ISO_PUBLISHER_XPATH))
        docid = ref.at(ns("./docidentifier"))
        return ref_names(ref) unless docid
        date = ref.at(ns("./date[@type = 'published']"))
        reference = format_ref(docid.text, isopub)
        reference += ": #{date.text}" if date && isopub
        @anchors[ref["id"]] = { xref: reference }
      end


    end
  end
end
