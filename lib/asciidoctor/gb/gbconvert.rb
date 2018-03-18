require "isodoc"
require_relative "./xref_gen.rb"
require_relative "./metadata.rb"
require_relative "./agencies.rb"
require_relative "./section_output.rb"

module Asciidoctor
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class GbConvert < IsoDoc::Convert
      def initialize(options)
        super
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

      def fileloc(loc)
        File.join(File.dirname(__FILE__), loc)
      end

      def generate_header(filename, dir)
        super
        system "cp #{fileloc(File.join('html', 'blank.png'))} blank.png"
      end

      def cleanup(docxml)
        super
        # intro_cleanup(docxml)
        terms_cleanup(docxml)
      end

      def term_merge(docxml, term_class)
        docxml.xpath("//p[@class = '#{term_class}']").each do |t|
          t1 = t.next_element || next
          if t1.name == "p" && t1["class"] == term_class
            t.add_child(" ")
            t.add_child(t1.remove.children)
          end
        end
      end

      def deprecated_single_label(docxml)
        docxml.xpath("//p[@class = 'Terms']").each do |t|
          t.xpath("//p[@class = 'DeprecatedTerms']").each_with_index do |d, i|
            next if i == 0
            d.children.first.content =
              d.children.first.content.sub(/^#{@deprecated_lbl}:\s*/, "")
          end
        end
      end

      def terms_cleanup(docxml)
        term_merge(docxml, "Terms")
        term_merge(docxml, "AltTerms")
        deprecated_single_label(docxml)
        term_merge(docxml, "DeprecatedTerms")
        docxml
      end
      
      def intro_cleanup(docxml)
        # insert tab for purposes of ToC lining up
        docxml.xpath("//h1[@class = 'IntroTitle']").each do |h1|
          if h1.content == "引言"
            h1.add_child('<span style="mso-tab-count:1">&#xA0; </span>')
          end
        end
      end

      def deprecated_term_parse(node, out)
        out.p **{ class: "DeprecatedTerms" } do |p|
          p << l10n("#{@deprecated_lbl}: ")
          node.children.each { |c| parse(c, p) }
        end
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
