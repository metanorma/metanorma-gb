module IsoDoc
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class WordConvert < IsoDoc::WordConvert
      def example_table_parse(node, out)
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

      def populate_template(docxml, format)
        meta = @meta.get.merge(@labels)
        logo = @common.format_logo(meta[:gbprefix], meta[:gbscope], format, @localdir)
        logofile = @meta.standard_logo(meta[:gbprefix])
        @files_to_delete << logofile + ".gif" unless logofile.nil?
        docxml = termref_resolve(docxml)
        meta[:standard_agency_formatted] =
          @common.format_agency(meta[:standard_agency], format, @localdir)
        meta[:standard_logo] = logo
        template = Liquid::Template.parse(docxml)
        template.render(meta.map { |k, v| [k.to_s, v] }.to_h)
      end

      def annex_name(annex, name, div)
        div.h1 **{ class: "Annex" } do |t|
          t << "#{get_anchors[annex['id']][:label]}<br/><br/>"
          name&.children&.each { |c2| parse(c2, t) }
        end
      end

      def term_defs_boilerplate(div, source, term, preface)
        (source.empty? && term.nil?) and div << @no_terms_boilerplate or
          div << term_defs_boilerplate_cont(source, term)
        #div << @term_def_boilerplate unless preface
      end
    end
  end
end

