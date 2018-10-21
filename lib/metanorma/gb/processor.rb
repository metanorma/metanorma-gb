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
          doc: "doc"
        )
      end

      def version
        "Metanorma::Gb #{Metanorma::Gb::VERSION}"
      end

      def input_to_isodoc(file)
        Metanorma::Input::Asciidoc.new.process(file, @asciidoctor_backend)
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

      def output(isodoc_node, outname, format, options={})
        case format
        when :html
          IsoDoc::Gb::HtmlConvert.new(options).convert(outname, isodoc_node)
        when :compliant_html
          IsoDoc::Gb::HtmlConvert.new(options.merge(compliant: true)).convert(outname, isodoc_node)
        when :doc
          IsoDoc::Gb::WordConvert.new(options).convert(outname, isodoc_node)
        else
          super
        end
      end
    end
  end
end
