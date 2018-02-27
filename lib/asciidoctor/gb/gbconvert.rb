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

      def note_label(node)
        n = get_anchors()[node["id"]]
        return "注" if n.nil?
        "�#{�n[:label]}"
      end

    def figure_name_parse(node, div, name)
      div.p **{ class: "FigureTitle", align: "center" } do |p|
        p.b do |b|
          b << "图#{get_anchors()[node['id']][:label]}"
          b << "&nbsp;&mdash; #{name.text}" if name
        end
      end
    end

    def table_title_parse(node, out)
      name = node.at(ns("./name"))
        out.p **{ class: "TableTitle", align: "center" } do |p|
          p.b do |b|
            b << "表#{get_anchors()[node['id']][:label]}"
            b << "&nbsp;&mdash; #{name.text}" if name
          end
        end
    end

      def figure_key(out)
        out.p do |p|
          p.b { |b| b << "说明" }
        end
      end

      def formula_where(dl, out)
        out.p { |p| p << "式中" }
        parse(dl, out)
      end

      def figure_get_or_make_dl(t)
        dl = t.at(".//dl")
        if dl.nil?
          t.add_child("<p><b>说明</b></p><dl></dl>")
          dl = t.at(".//dl")
        end
        dl
      end

    def example_label(node)
      n = get_anchors()[node["id"]]
      return "示例" if n.nil? || n[:label].empty?
      "示例#{n[:label]}"
    end

      def deprecated_term_parse(node, out)
        out.p **{ class: "DeprecatedTerms" } do |p|
          p << "被取代: #{node.text}"
        end
      end

      def termexample_parse(node, out)
        out.div **{ class: "Note" } do |div|
          first = node.first_element_child
          div.p **{ class: "Note" } do |p|
            p << "示例:"
            insert_tab(p, 1)
            para_then_remainder(first, node, p)
          end
        end
      end

      LOCALITY = {
        section: "条",
        clause: "条",
        part: "部分",
        paragraph: "段",
        chapter: "章",
        page: "页",
      }.freeze

      def eref_localities(r)
        ret = ""
        r.each do |r|
          if r["type"] == "whole"
            ret += ", 全部"
          else
            refFrom = r.at(ns("./referenceFrom"))
            refTo = r.at(ns("./referenceTo"))
            ret += ", 第#{refFrom.text}" if refFrom
            ret += "&ndash;#{refTo}" if refTo
            ret += "#{LOCALITY[r["type"].to_sym]}"
          end
        end
        ret
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
        intro_cleanup(docxml)
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

      def terms_cleanup(docxml)
        term_merge(docxml, "Terms")
        term_merge(docxml, "AltTerms")
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

      def sentence_join(array)
        return "" if array.nil? || array.empty?
        if array.length == 1
          result = array[0]
        else
          result = "#{array[0..-2].join('、 ')} 和 #{array.last}"
        end
      end
    end
  end
end
