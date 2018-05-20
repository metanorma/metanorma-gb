require "isodoc"

module IsoDoc
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation

    class WordConvert < IsoDoc::Gb::Convert
      include IsoDoc::WordConvertModule

      def initialize(options)
        super
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

      def toWord(result, filename, dir)
        result = populate_template(result, :word)
        result = from_xhtml(word_cleanup(to_xhtml(result)))
        Html2Doc.process(result, filename: filename,
                         stylesheet: @wordstylesheet,
                         header_file: "header.html", dir: dir,
                         asciimathdelims: [@openmathdelim, @closemathdelim],
                         liststyles: {ul: "l7", ol: "l10"})
      end
    end
  end
end
