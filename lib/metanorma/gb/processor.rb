require "metanorma/processor"

module Metanorma
  module Gb
    class Processor < Metanorma::Processor

      def initialize
        @short = :gb
        @input_format = :asciidoc
        @asciidoctor_backend = :gb
      end

      def output_formats
        super.merge(
          html: "html",
          compliant_html: "compliant.html",
          doc: "doc",
          pdf: "pdf",
        )
      end

      def version
        "Metanorma::Gb #{Metanorma::Gb::VERSION}"
      end

      def extract_options(file)
        head = file.sub(/\n\n.*$/m, "\n")
        /\n:standard-logo-img: (?<standardlogoimg>[^\n]+)\n/ =~ head
        /\n:standard-class-img: (?<standardclassimg>[^\n]+)\n/ =~ head
        /\n:standard-issuer-img: (?<standardissuerimg>[^\n]+)\n/ =~ head
        /\n:title-font: (?<titlefont>[^\n]+)\n/ =~ head
        new_options = {
          standardlogoimg: defined?(standardlogoimg) ? standardlogoimg : nil,
          standardclassimg: defined?(standardclassimg) ? standardclassimg : nil,
          standardissuerimg: defined?(standardissuerimg) ? standardissuerimg : nil,
          titlefont: defined?(titlefont) ? titlefont : nil,
        }.reject { |_, val| val.nil? }
        super.merge(new_options)
      end

      def use_presentation_xml(ext)
        return true if ext == :compliant_html
        super
      end

      def output(isodoc_node, inname, outname, format, options={})
        case format
        when :html
          IsoDoc::Gb::HtmlConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :compliant_html
          IsoDoc::Gb::HtmlConvert.new(options.merge(compliant: true)).convert(inname, isodoc_node, nil, outname)
        when :doc
          IsoDoc::Gb::WordConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :pdf
          IsoDoc::Gb::PdfConvert.new(options).convert(inname, isodoc_node, nil, outname)
        when :presentation
          IsoDoc::Gb::PresentationXMLConvert.new(options).convert(inname, isodoc_node, nil, outname)
        else
          super
        end
      end
    end
  end
end
