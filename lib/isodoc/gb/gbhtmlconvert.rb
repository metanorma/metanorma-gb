require_relative "gbconvert"

module IsoDoc
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class Convert < IsoDoc::Convert
      def default_fonts(options)
        script = options[:script] || "Hans"
        b = options[:bodyfont] ||
          (script == "Hans" ? '"SimSun",serif' :
           script == "Latn" ? '"Cambria",serif' : '"SimSun",serif' )
        h = options[:headerfont] ||
          (script == "Hans" ? '"SimHei",sans-serif' :
           script == "Latn" ? '"Calibri",sans-serif' : '"SimHei",sans-serif' )
        m = options[:monospacefont] || '"Courier New",monospace'
        scope = options[:scope] || "national"
        t = options[:titlefont] ||
          (scope == "national" ? (script != "Hans" ? '"Cambria",serif' : '"SimSun",serif' ) :
           (script == "Hans" ? '"SimHei",sans-serif' : '"Calibri",sans-serif' ))
        "$bodyfont: #{b};\n$headerfont: #{h};\n$monospacefont: #{m};\n$titlefont: #{t};\n"
      end

      def initialize(options)
        super
        @htmlstylesheet = generate_css(html_doc_path("htmlstyle.scss"), true, default_fonts(options))
        @standardstylesheet = generate_css(html_doc_path("gb.scss"), true, default_fonts(options))
        @htmlcoverpage = html_doc_path("html_gb_titlepage.html")
        @htmlintropage = html_doc_path("html_gb_intro.html")
        @scripts = html_doc_path("scripts.html")
      end

      def html_doc_path(file)
        File.join(File.dirname(__FILE__), File.join("html", file))
      end

      def formula_parse(node, out)
        Common::formula_parse(node, out)
      end

      def formula_where(dl, out)
        Common::formula_where(dl, out)
      end

      def formula_dl_parse(node, out)
        Common::formula_dl_parse(node, out)
      end

      def example_parse(node, out)
        Common::formula_dl_parse(node, out)
      end

      def note_parse(node, out)
        Common::def note_parse(node, out)
      end

      def termnote_parse(node, out)
        Common::termnote_parse(node, out)
      end

      def cleanup(docxml)
        Common::cleanup(docxml)
      end

      def example_cleanup(docxml)
        Common::example_cleanup(docxml)
      end

      def middle(isoxml, out)
        Common::middle(isoxml, out)
      end

      def error_parse(node, out)
        Common::error_parse(node, out)
      end

      def deprecated_term_parse(node, out) 
        Common::deprecated_term_parse(node, out)
      end

      def termref_render(x)
        Common::termref_render(x)
      end

      def populate_template(docxml, format)
        Common::populate_template(docxml, format)
      end

      def i18n_init(lang, script)
        Common::i18n_init(lang, script)
      end

      def init_metadata
        Common::init_metadata
      end

      def title(isoxml, _out)
        Common::title(isoxml, _out)
      end

      def subtitle(isoxml, _out)
        Common::subtitle(isoxml, _out)
      end

      def author(isoxml, _out)
        Common::author(isoxml, _out)
      end

      def docstatus(isoxml, _out)
        Common::docstatus(isoxml, _out)
      end

      def docid(isoxml, _out)
        Common::docid(isoxml, _out)
      end

      def part_label(partnumber, lang)
        Common::part_label(partnumber, lang)
      end

      def bibdate(isoxml, _out)
        Common::bibdate(isoxml, _out)
      end

      def foreword(isoxml, out)
        Common::foreword(isoxml, out)
      end

      def clause_name(num, title, div, header_class)
        Common::clause_name(num, title, div, header_class)
      end

      def clause_parse_title(node, div, c1, out)
        Common::clause_parse_title(node, div, c1, out)
      end

      def annex_name(annex, name, div)
        Common::annex_name(annex, name, div)
      end

      def term_defs_boilerplate(div, source, term, preface)
        Common::term_defs_boilerplate(div, source, term, preface)
      end

      def reference_names(ref)
        Common::reference_names(ref)
      end


    end
  end
end

