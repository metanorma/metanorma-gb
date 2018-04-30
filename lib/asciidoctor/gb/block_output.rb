module Asciidoctor
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class GbConvert < IsoDoc::Convert
      def formula_parse(node, out)
        out.div **attr_code(id: node["id"], class: "formula") do |div|
          insert_tab(div, 1)
          parse(node.at(ns("./stem")), out)
          insert_tab(div, 1)
          div << "(#{get_anchors[node['id']][:label]})"
        end
        formula_where(node.at(ns("./dl")), out)
      end

      def formula_where(dl, out)
        return unless dl
        out.p { |p| p << @where_lbl }
        formula_dl_parse(dl, out)
      end

      def formula_dl_parse(node, out)
        out.table **{ class: "dl" } do |v|
          node.elements.each_slice(2) do |dt, dd|
            v.tr do |tr|
              tr.td **{ valign: "top", align: "left" } do |term|
                dt_parse(dt, term)
              end
              tr.td **{ valign: "top" } { |td| td << "&mdash;" }
              tr.td **{ valign: "top" } do |listitem|
                dd.children.each { |n| parse(n, listitem) }
              end
            end
          end
        end
      end

      EXAMPLE_TBL_ATTR =
        { valign: "top", class: "example_label",
          style: "padding:2pt 2pt 2pt 2pt" }.freeze

      def example_parse(node, out)
        out.table **attr_code(id: node["id"], class: "example") do |t|
          t.tr do |tr|
            tr.td **EXAMPLE_TBL_ATTR do |td|
              td << l10n(example_label(node) + ":")
            end
            tr.td **{ valign: "top", class: "example" } do |td|
              node.children.each { |n| parse(n, td) }
            end
          end
        end
      end

      def note_parse(node, out)
        @note = true
        out.table **attr_code(id: node["id"], class: "Note") do |t|
          t.tr do |tr|
            tr.td **EXAMPLE_TBL_ATTR do |td|
              td << l10n(note_label(node) + ":")
            end
            tr.td **{ valign: "top", class: "Note" } do |td|
              node.children.each { |n| parse(n, td) }
            end
          end
        end
        @note = false
      end

      def termnote_parse(node, out)
        @note = true
        out.table **attr_code(id: node["id"], class: "Note") do |t|
          t.tr do |tr|
            tr.td **EXAMPLE_TBL_ATTR do |td|
              td << l10n("#{get_anchors[node['id']][:label]}:")
            end
            tr.td **{ valign: "top", class: "Note" } do |td|
              node.children.each { |n| parse(n, td) }
            end
          end
        end
        @note = false
      end
    end
  end
end
