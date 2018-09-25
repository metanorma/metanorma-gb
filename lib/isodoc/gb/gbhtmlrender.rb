module IsoDoc
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class HtmlConvert < IsoDoc::HtmlConvert
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
              tr.td(**{ valign: "top" }) { |td| td << "&mdash;" }
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
        parts = x.split(%r{(\s*\[MODIFICATION\]|,)}m)
        parts[1] = l10n(", #{@source_lbl}") if parts.size > 1 && parts[1] == ","
        parts.map do |p|
          /\s*\[MODIFICATION\]/.match?(p) ? l10n(", #{@modified_lbl} &mdash; ") : p
        end.join.sub(/\A\s*/m, l10n("[")).sub(/\s*\z/m, l10n("]"))
      end

      def termref_resolve(docxml)
        docxml.split(%r{(\[TERMREF\]|\[/TERMREF\])}).each_slice(4).
          map do |a|
          a.size < 3 ? a[0] : a[0] + termref_render(a[2])
        end.join
      end

      def populate_template(docxml, format)
        meta = @meta.get.merge(@labels)
        logo = @common.format_logo(meta[:gbprefix], meta[:gbscope], format)
        logofile = @meta.standard_logo(meta[:gbprefix])
        @files_to_delete << logofile + ".gif" unless logofile.nil?
        docxml = termref_resolve(docxml)
        meta[:standard_agency_formatted] =
          @common.format_agency(meta[:standard_agency], format)
        meta[:standard_logo] = logo
        template = Liquid::Template.parse(docxml)
        template.render(meta.map { |k, v| [k.to_s, v] }.to_h)
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

      def clause_name(num, title, div, header_class)
        header_class = {} if header_class.nil?
        div.h1 **attr_code(header_class) do |h1|
          if num && !@suppressheadingnumbers
            h1 << "#{num}."
            h1 << "&#x3000;"
          end
          h1 << title
        end
        div.parent.at(".//h1")
      end

      def clause_parse_title(node, div, c1, out)
        if node["inline-header"] == "true"
          inline_header_title(out, node, c1)
        else
          div.send "h#{get_anchors[node['id']][:level]}" do |h|
            h << "#{get_anchors[node['id']][:label]}.&#x3000;" if !@suppressheadingnumbers
            c1 and c1.children.each { |c2| parse(c2, h) }
          end
        end
      end

      def annex_name(annex, name, div)
        div.h1 **{ class: "Annex" } do |t|
          t << "#{get_anchors[annex['id']][:label]}<br/><br/>"
          t << name.text
        end
      end

      def term_defs_boilerplate(div, source, term, preface)
        unless preface
          (source.empty? && term.nil?) and div << @no_terms_boilerplate or
            div << term_defs_boilerplate_cont(source, term)
        end
        #div << @term_def_boilerplate unless preface
      end

=begin
      def reference_names(ref)
        isopub = ref.at(ns(ISO_PUBLISHER_XPATH))
        docid = ref.at(ns("./docidentifier"))
        date = ref.at(ns("./date[@type = 'published']"))
        allparts = ref.at(ns("./allparts"))
        reference = format_ref(docid.text, isopub, date, allparts)
        @anchors[ref["id"]] = { xref: reference }
      end
=end
    end
  end
end

