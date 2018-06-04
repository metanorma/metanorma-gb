require "isodoc"
require_relative "./gbconvert"

module IsoDoc
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation

    class WordConvert < IsoDoc::WordConvert
      #include IsoDoc::WordConvertModule
      def html_doc_path(file)
        File.join(File.dirname(__FILE__), File.join("html", file))
      end

      def initialize(options)
        super
        @wordstylesheet = generate_css(html_doc_path("wordstyle.scss"), false, default_fonts(options))
        @standardstylesheet = generate_css(html_doc_path("gb.scss"), false, default_fonts(options))
        @header = html_doc_path("header.html")
        @wordcoverpage = html_doc_path("word_gb_titlepage.html")
        @wordintropage = html_doc_path("word_gb_intro.html")
        @ulstyle = "l7"
        @olstyle = "l10"
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

      def generate_header(filename, dir)
        return unless @header
        template = Liquid::Template.parse(File.read(@header, encoding: "UTF-8"))
        meta = get_metadata
        meta[:filename] = filename
        params = meta.map { |k, v| [k.to_s, v] }.to_h
        File.open("header.html", "w") { |f| f.write(template.render(params)) }
        system "cp #{fileloc(File.join('html', 'blank.png'))} blank.png"
        @files_to_delete << "blank.png"
        @files_to_delete << "header.html"
      end

      def header_strip(h)
        h = h.to_s.gsub(%r{<br/>}, " ").sub(/<\/?h[12][^>]*>/, "")
        h1 = to_xhtml_fragment(h.dup)
        h1.traverse do |x|
          x.replace(" ") if x.name == "span" &&
            /mso-tab-count/.match?(x["style"])
          x.remove if x.name == "span" && x["class"] == "MsoCommentReference"
          x.remove if x.name == "a" && x["epub:type"] == "footnote"
          x.replace(x.children) if x.name == "a"
        end
        from_xhtml(h1)
      end

      def word_cleanup(docxml)
        word_preface(docxml)
        word_annex_cleanup(docxml)
        title_cleanup(docxml.at('//div[@class="WordSection2"]'))
        docxml
      end

      #def word_intro(docxml)
      #super
      #title_cleanup(docxml.at('//div[@class="WordSection2"]'))
      #end

=begin
      def toWord(result, filename, dir)
        result = populate_template(result, :word)
        result = from_xhtml(word_cleanup(to_xhtml(result)))
        Html2Doc.process(result, filename: filename,
                         stylesheet: @wordstylesheet,
                         header_file: "header.html", dir: dir,
                         asciimathdelims: [@openmathdelim, @closemathdelim],
                         liststyles: {ul: "l7", ol: "l10"})
      end
=end


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
