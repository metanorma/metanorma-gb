require "isodoc"
require_relative "./xref_gen.rb"
require_relative "./metadata.rb"
require_relative "./agencies.rb"
require_relative "./section_output.rb"
require_relative "./block_output.rb"

module Asciidoctor
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class GbConvert < IsoDoc::Convert
      def initialize(options)
        super
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

      def fileloc(loc)
        File.join(File.dirname(__FILE__), loc)
      end

      def generate_header(filename, dir)
        super
        system "cp #{fileloc(File.join('html', 'blank.png'))} blank.png"
      end

      def cleanup(docxml)
        super
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
        super
        docxml.xpath("//table[@class = 'Note']//p[not(@class)]").each do |p|
          p["class"] = "Note"
        end
        docxml
      end

      def spaerdruck(x, return_on_br)
        x.traverse do |n|
          n.text? and n.content = n.text.gsub(/(.)(?!\s*$)/, "\\1\u00a0\u00a0")
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

      def local_logo_suffix(scope)
        return "" if scope != "local"
        local = get_metadata[:docidentifier][2,2]
        "<span style='font-weight:bold'>#{local}</span>"
      end

      def format_logo(prefix, scope, _format)
        logo = standard_logo(prefix)
        if logo.nil?
          "<span style='font-size:36pt;font-weight:bold'>#{prefix}</span>"
        else
          logo += ".gif"
          system "cp #{fileloc(File.join('html/gb-logos', logo))}  #{logo}"
          local = local_logo_suffix(scope)
          "<img width='113' height='56' src='#{logo}' alt='#{prefix}'></img>"\
            "#{local}"
        end
      end

      def format_agency(agency, format)
        return agency unless agency.is_a?(Array)
        ret = "<table>"
        agency.each { |a| ret += "<tr><td>#{a}</td></tr>" }
        ret += "</table>"
        ret.gsub!(/<table>/, "<table width='100%'>") if format == :word
        ret
      end

      def termref_render(x)
        parts = x.split(%r{(\s*\[MODIFICATION\]|,)}m)
        parts[1] = "，定义" if parts.size > 1 && parts[1] == ","
        parts.map do |p|
          /\s*\[MODIFICATION\]/.match?(p) ? ", 改写 &mdash; " : p
        end.join.sub(/\A\s*/m, "【").sub(/\s*\z/m, "】")
      end

      def termref_resolve(docxml)
        docxml.split(%r{(\[TERMREF\]|\[/TERMREF\])}).each_slice(4).
          map do |a|
          a.size < 3 ? a[0] : a[0] + termref_render(a[2])
        end.join
      end

      def populate_template(docxml, format)
        meta = get_metadata.merge(@labels)
        logo = format_logo(meta[:gbprefix], meta[:gbscope], format)
        docxml = termref_resolve(docxml)
        docxml.gsub!(/\s*\[ISOSECTION\]/, ", ?~Z?~I")
        meta[:standard_agency_formatted] =
          format_agency(meta[:standard_agency], format)
        meta[:standard_logo] = logo
        template = Liquid::Template.parse(docxml)
        template.render(meta.map { |k, v| [k.to_s, v] }.to_h)
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
