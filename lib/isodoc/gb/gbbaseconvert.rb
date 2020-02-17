require_relative "gbconvert"
require "gb_agencies"
require_relative "gbcleanup"
require_relative "metadata"
require "fileutils"

module IsoDoc
  module Gb
    module BaseConvert
      def extract_fonts(options)
        b = options[:bodyfont] || "Arial"
        h = options[:headerfont] || "Arial"
        m = options[:monospacefont] || "Courier"
        t = options[:titlefont] || "Arial"
        "$bodyfont: #{b};\n$headerfont: #{h};\n$monospacefont: #{m};\n$titlefont: #{t};\n"
      end   

      def metadata_init(lang, script, labels)
        unless ["en", "zh"].include? lang
          lang = "zh"
          script = "Hans"
        end
        @meta = Metadata.new(lang, script, labels)
        @meta.set(:standardclassimg, @standardclassimg)
        @common.meta = @meta
      end

      def cleanup(docxml)
        @cleanup = Cleanup.new(@script, @deprecated_lbl)
        super
        @cleanup.cleanup(docxml)
        docxml
      end

      def example_cleanup(docxml)
        super
        @cleanup.example_cleanup(docxml)
      end

      def i18n_init(lang, script)
        super
        y = if lang == "en"
              YAML.load_file(File.join(File.dirname(__FILE__), "i18n-en.yaml"))
            elsif lang == "zh" && script == "Hans"
              YAML.load_file(File.join(File.dirname(__FILE__),
                                       "i18n-zh-Hans.yaml"))
            else
              YAML.load_file(File.join(File.dirname(__FILE__), "i18n-zh-Hans.yaml"))
            end
        @labels = @labels.merge(y)
      end

      def omit_docid_prefix(prefix)
        super || prefix == "Chinese Standard"
      end

      def formula_parse(node, out)
        out.div **attr_code(id: node["id"], class: "formula") do |div|
          insert_tab(div, 1)
          parse(node.at(ns("./stem")), out)
          lbl = anchor(node['id'], :label, false)
          unless lbl.nil?
            insert_tab(div, 1)
            div << "(#{lbl})"
          end
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

      def example_label(node)
        l10n(super + ":")
      end

      def note_parse(node, out)
        @note = true
        out.table **attr_code(id: node["id"], class: "Note") do |t|
          t.tr do |tr|
            @libdir = File.dirname(__FILE__)
            tr.td **EXAMPLE_TBL_ATTR do |td|
              td << l10n(note_label(node) + ":")
            end
            tr.td **{ style: "vertical-align:top;", class: "Note" } do |td|
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
              td << l10n("#{anchor(node['id'], :label)}:")
            end
            tr.td **{ style: "vertical-align:top;", class: "Note" } do |td|
              node.children.each { |n| parse(n, td) }
            end
          end
        end
        @note = false
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
          p << l10n("#{@deprecated_lbl}: ")
          node.children.each { |c| parse(c, p) }
        end
      end

      def termref_render(x)
        x.sub!(%r{\s*\[MODIFICATION\]\s*$}m, l10n(", #{@modified_lbl}"))
        parts = x.split(%r{(\s*\[MODIFICATION\]|,)}m)
        parts[1] = l10n(", #{@source_lbl}") if parts.size > 1 && parts[1] == "," &&
          !/^\s*#{@modified_lbl}/.match(parts[2])
          parts.map do |p|
            /\s*\[MODIFICATION\]/.match(p) ? l10n(", #{@modified_lbl} &mdash; ") : p
          end.join.sub(/\A\s*/m, l10n("[")).sub(/\s*\z/m, l10n("]"))
      end

      def termref_resolve(docxml)
        docxml.split(%r{(\[TERMREF\]|\[/TERMREF\])}).each_slice(4).
          map do |a|
          a.size < 3 ? a[0] : a[0] + termref_render(a[2])
        end.join
      end

      def foreword(isoxml, out)
        f = isoxml.at(ns("//foreword")) || return
        page_break(out)
        out.div do |s|
          s.h1 **{ class: "ForewordTitle" } do |h1|
            h1 << "#{@foreword_lbl}&nbsp;"
            # insert_tab(h1, 1)
          end
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      def clausedelimspace(out)
        out << "&#x3000;"
      end

      def clause_name(num, title, div, header_class)
        header_class = {} if header_class.nil?
        div.h1 **attr_code(header_class) do |h1|
          if num && !@suppressheadingnumbers
            h1 << "#{num}."
            h1 << "&#x3000;"
          end
          title.is_a?(String) ? h1 << title :
          title&.children&.each { |c2| parse(c2, h1) }
        end
        div.parent.at(".//h1")
      end

      def example_span_label(node, div, name)
        n = get_anchors[node["id"]]
        div.span **{ class: "example_label" } do |p|
          lbl = (n.nil? || n[:label].nil? || n[:label].empty?) ? @example_lbl :
            l10n("#{@example_lbl} #{n[:label]}")
          p << l10n(lbl + ":")
          name and !lbl.nil? and p << "&nbsp;&mdash; "
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
          if node_begins_with_para(node)
            example_p_parse(node, div)
          else
            example_parse1(node, div)
          end
        end
      end

      def textcleanup(docxml)
        termref_resolve(docxml)
      end
    end
  end
end
