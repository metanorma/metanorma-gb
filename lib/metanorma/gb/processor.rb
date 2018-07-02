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
          doc: "doc"
        )
      end

      def version
        "Asciidoctor::Gb #{Asciidoctor::Gb::VERSION}"
      end

      def input_to_isodoc(file)
        Metanorma::Input::Asciidoc.new.process(file, @asciidoctor_backend)
      end

      def output(isodoc_node, outname, format, options={})
        case format
        when :html
          IsoDoc::Gb::HtmlConvert.new(options).convert(outname, isodoc_node)
        when :doc
          IsoDoc::Gb::WordConvert.new(options).convert(outname, isodoc_node)
        else
          super
        end
      end
    end
  end
end
