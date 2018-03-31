require "isodoc"

module Asciidoctor
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    
    class GbWordConvert < GbConvert
      include IsoDoc::WordConvertModule

      def initialize(options)
        super
      end

      def generate_header(filename, dir)
        return unless @header
        template = Liquid::Template.parse(File.read(@header, encoding: "UTF-8"))
        meta = get_metadata
        meta[:filename] = filename
        params = meta.map { |k, v| [k.to_s, v] }.to_h
        File.open("header.html", "w") do |f|
          f.write(template.render(params))
        end
        system "cp #{fileloc(File.join('html', 'blank.png'))} blank.png"
      end

      def header_strip(h)
        h = h.to_s.gsub(%r{<br/>}, " ").sub(/<\/?h[12][^>]*>/, "")
        h1 = to_xhtml_fragment(h.dup)
        h1.traverse do |x|
          x.replace(" ") if x.name == "span" && /mso-tab-count/.match?(x["style"])
          x.remove if x.name == "span" && x["class"] == "MsoCommentReference"
          x.remove if x.name == "a" && x["epub:type"] == "footnote"
          if x.name == "a"
            x.replace(x.children)
          end
        end
        from_xhtml(h1)
      end

      def toWord(result, filename, dir)
        result = from_xhtml(word_cleanup(to_xhtml(result)))
        result = populate_template(result, :word)
        Html2Doc.process(result, filename: filename, stylesheet: @wordstylesheet,
                         header_file: "header.html", dir: dir,
                         asciimathdelims: [@openmathdelim, @closemathdelim],
                         liststyles: {ul: "l7", ol: "l10"})
      end
    end
  end
end
