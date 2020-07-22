require_relative "common"
require "gb_agencies"
require_relative "cleanup"
require "fileutils"

module IsoDoc
  module Gb
    module BaseConvert
      def extract_fonts(options)
        b = options[:bodyfont] || "Arial"
        h = options[:headerfont] || "Arial"
        m = options[:monospacefont] || "Courier"
        t = options[:titlefont] || "Arial"
        "$bodyfont: #{b};\n$headerfont: #{h};\n$monospacefont: #{m};\n"\
          "$titlefont: #{t};\n"
      end   

      def cleanup(docxml)
        @i18n ||= i18n_init(@lang, @script)
        @cleanup = Cleanup.new(@script, @i18n.deprecated)
        super
        @cleanup.cleanup(docxml)
        docxml
      end

      def example_cleanup(docxml)
        super
        @cleanup.example_cleanup(docxml)
      end

      def omit_docid_prefix(prefix)
        super || prefix == "Chinese Standard"
      end

      def formula_parse1(node, out)
         out.div **attr_code(class: "formula") do |div|
          insert_tab(div, 1)
          parse(node.at(ns("./stem")), div)
          lbl = node&.at(ns("./name"))&.text
          unless lbl.nil?
            insert_tab(div, 1)
            div << "(#{lbl})"
          end
        end
      end

      def formula_where(dl, out)
        return unless dl
        out.p **{ style: "page-break-after:avoid;"} do |p|
          p << @i18n.where
        end
        formula_dl_parse(dl, out)
      end

      def formula_dl_parse(node, out)
        out.table **{ class: "formula_dl" } do |v|
          node.elements.each_slice(2) do |dt, dd|
            v.tr do |tr|
              tr.td **{ style: "vertical-align:top;text-align:left;" } do |term|
                dt_parse(dt, term)
              end
              tr.td(**{ style: "vertical-align:top;" }) { |td| td << "&mdash;" }
              tr.td **{ style: "vertical-align:top;" } do |listitem|
                dd.children.each { |n| parse(n, listitem) }
              end
            end
          end
        end
      end

      EXAMPLE_TBL_ATTR =
        { class: "example_label",
          style: "padding:2pt 2pt 2pt 2pt;vertical-align:top;" }.freeze

      def note_delim
        l10n(": ")
      end

      def note_parse(node, out)
        note_parse_table(node, out)
      end

      def note_parse_table(node, out)
        @note = true
        name = node&.at(ns("./name"))&.remove
        note_parse_table1(node, out, name)
        @note = false
      end

      def note_parse_table1(node, out, name)
        out.table **note_attrs(node) do |t|
          t.tr do |tr|
            tr.td **EXAMPLE_TBL_ATTR do |td|
              name and name.children.each { |n| parse(n, td) }
              td << note_delim
            end
            tr.td **{ style: "vertical-align:top;", class: "Note" } do |td|
              node.children.each { |n| parse(n, td) }
            end
          end
        end
      end

      def termnote_parse(node, out)
        note_parse_table(node, out)
      end

      def middle(isoxml, out)
        super
        end_line(isoxml, out)
      end

      def end_line(_isoxml, out)
        out.hr **{ width: "25%" }
      end

      def error_parse(node, out)
        # catch elements not defined in ISO
        case node.name
        when "string" then string_parse(node, out)
        else
          super
        end
      end

      def string_parse(node, out)
        if node["script"] == "Hant"
          out.span **{ class: "Hant" } do |s|
            node.children.each { |c| parse(c, s) }
          end
        else
          node.children.each { |c| parse(c, out) }
        end
      end

      def deprecated_term_parse(node, out)
        out.p **{ class: "DeprecatedTerms" } do |p|
          p << l10n("#{@i18n.deprecated}: ")
          node.children.each { |c| parse(c, p) }
        end
      end

      def termref_render(x)
        x.sub!(%r{\s*\[MODIFICATION\]\s*$}m, l10n(", #{@i18n.modified}"))
        parts = x.split(%r{(\s*\[MODIFICATION\]|,)}m)
        parts[1] = l10n(", #{@i18n.source}") if parts.size > 1 &&
          parts[1] == "," && !/^\s*#{@i18n.modified}/.match(parts[2])
          parts.map do |p|
            /\s*\[MODIFICATION\]/.match(p) ?
              l10n(", #{@i18n.modified} &mdash; ") : p
          end.join.sub(/\A\s*/m, l10n("[")).sub(/\s*\z/m, l10n("]"))
      end

      def termref_resolve(docxml)
        docxml.gsub(%r{\s*\[/TERMREF\]\s*</p>\s*<p>\s*\[TERMREF\]}, l10n("; ")).
          split(%r{(\[TERMREF\]|\[/TERMREF\])}).each_slice(4).
          map do |a|
          a.size < 3 ? a[0] : a[0] + termref_render(a[2])
        end.join
      end

      def clausedelimspace(out)
        out << "&#x3000;"
      end

      def example_span_label(node, div, name)
        div.span **{ class: "example_label" } do |p|
          name and name.children.each { |n| parse(n, div) }
        end
      end

      def example_p_parse(node, div)
        name = node&.at(ns("./name"))&.remove
        div.p do |p|
          example_span_label(node, p, name)
          insert_tab(p, 1)
          node.first_element_child.children.each { |n| parse(n, p) }
        end
        node.element_children[1..-1].each { |n| parse(n, div) }
      end

      def example_parse1(node, div)
        div.p do |p|
          example_span_label(node, p, node.at(ns("./name")))
          insert_tab(p, 1)
        end
        node.children.each { |n| parse(n, div) unless n.name == "name" }
      end

      def node_begins_with_para(node)
        node.elements.each do |e|
          next if e.name == "name"
          return true if e.name == "p"
          return false
        end
        false
      end

      def example_parse(node, out)
        out.div **{ id: node["id"], class: "example" } do |div|
          node_begins_with_para(node) ?
            example_p_parse(node, div) : example_parse1(node, div)
        end
      end

      def textcleanup(docxml)
        termref_resolve(docxml)
      end
    end
  end
end
