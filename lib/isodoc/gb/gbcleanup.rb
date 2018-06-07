module IsoDoc
  module Gb
    class Cleanup
      def initialize(script, deprecated_lbl)
        @script = script
        @deprecated_lbl = deprecated_lbl
      end

      def cleanup(docxml)
        terms_cleanup(docxml)
        formula_cleanup(docxml)
        title_cleanup(docxml)
        docxml
      end

      def formula_cleanup(docxml)
        docxml.xpath("//table[@class = 'dl']//p[not(@class)]").each do |p|
          p["class"] = "dl"
        end
        docxml
      end

      def example_cleanup(docxml)
        docxml.xpath("//table[@class = 'Note']//p[not(@class)]").each do |p|
          p["class"] = "Note"
        end
        docxml
      end

      def spaerdruck(x, return_on_br)
        x.traverse do |n|
          n.text? and n.content = n.text.gsub(/(.)/, "\\1\u00a0\u00a0").
            gsub(/\u00a0+$/, "")
          return_on_br and n.element? and n.name == "br" and return
        end
      end

      def title_cleanup(docxml)
        @script == "Hans" or return
        docxml.xpath("//*[@class = 'zzContents' or @class = 'ForewordTitle' or "\
                     "@class = 'IntroTitle'] | "\
                     "//h1[@class = 'Sections3']").each do |x|
          spaerdruck(x, false)
        end
        docxml.xpath("//h1[@class = 'Annex']").each do |x|
          spaerdruck(x, true)
        end
        docxml
      end

      def term_merge(docxml, term_class)
        docxml.xpath("//p[@class = '#{term_class}']").each do |t|
          t1 = t.next_element || next
          if t1.name == "p" && t1["class"] == term_class
            t.add_child("&#x3000;")
            t.add_child(t1.remove.children)
          end
        end
      end

      def deprecated_single_label(docxml)
        docxml.xpath("//p[@class = 'DeprecatedTerms']").each do |d|
          t1 = d.previous_element
          next unless t1 && t1.name == "p" && t1["class"] == "DeprecatedTerms"
          d.children.first.content =
            d.children.first.content.sub(/^#{@deprecated_lbl}:\s*/, "")
        end
      end

      def terms_cleanup(docxml)
        term_merge(docxml, "Terms")
        term_merge(docxml, "AltTerms")
        deprecated_single_label(docxml)
        term_merge(docxml, "DeprecatedTerms")
        docxml
      end

=begin
      def intro_cleanup(docxml)
        # insert tab for purposes of ToC lining up
        docxml.xpath("//h1[@class = 'IntroTitle']").each do |h1|
          if h1.content == "引言"
            h1.add_child('<span style="mso-tab-count:1">&#xA0; </span>')
          end
        end
      end
=end
    end
  end
end
