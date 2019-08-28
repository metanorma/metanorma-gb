require_relative "gbbaseconvert"
require "isodoc"

module IsoDoc
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class WordConvert < IsoDoc::WordConvert
      def initialize(options)
        @common = IsoDoc::Gb::Common.new(options)
        @standardclassimg = options[:standardclassimg]
        @libdir = File.dirname(__FILE__)
        super
        @lang = "zh"
        @script = "Hans"
      end

      def default_fonts(options)
        script = options[:script] || "Hans"
        scope = options[:scope] || "national"
        {
          bodyfont: (script == "Hans" ? '"SimSun",serif' : '"Cambria",serif'),
          headerfont: (script == "Hans" ? '"SimHei",sans-serif' : '"Calibri",sans-serif'),
          monospacefont: '"Courier New",monospace',
          titlefont: (scope == "national" ? (script != "Hans" ? '"Cambria",serif' : '"SimSun",serif' ) :
                      (script == "Hans" ? '"SimHei",sans-serif' : '"Calibri",sans-serif' ))
        }     
      end     

      def default_file_locations(options)
        {   
          wordstylesheet: html_doc_path("wordstyle.scss"),
          standardstylesheet: html_doc_path("gb.scss"),
          header: html_doc_path("header.html"),
          wordcoverpage: html_doc_path("word_gb_titlepage.html"),
          wordintropage: html_doc_path("word_gb_intro.html"),
          ulstyle: "l7",
          olstyle: "l10",
        }
      end 

      ENDLINE = <<~END.freeze
      <v:line id="_x0000_s1026"
 alt="" style='position:absolute;left:0;text-align:left;z-index:251662848;
 mso-wrap-edited:f;mso-width-percent:0;mso-height-percent:0;
 mso-width-percent:0;mso-height-percent:0'
 from="6.375cm,20.95pt" to="10.625cm,20.95pt"
 strokeweight="1.5pt"/>
      END

      def end_line(_isoxml, out)
        out.parent.add_child(ENDLINE)
      end

      def word_cleanup(docxml)
        word_preface(docxml)
        word_annex_cleanup(docxml)
        @cleanup.title_cleanup(docxml.at('//div[@class="WordSection2"]'))
        docxml
      end

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
          t << "#{anchor(annex['id'], :label)}<br/><br/>"
          name&.children&.each { |c2| parse(c2, t) }
        end
      end

      include BaseConvert
    end
  end
end
