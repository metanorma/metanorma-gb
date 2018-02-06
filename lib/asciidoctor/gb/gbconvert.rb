require "isodoc"

module Asciidoctor
  module Gb
    # A {Converter} implementation that generates CSD output, and a document
    # schema encapsulation of the document for validation
    class GbConvert < IsoDoc::Convert
      def initialize(options)
        super
      end

      def title(isoxml, _out)
        intro = isoxml.at(ns("//title[@language='zh']/title-intro"))
        main = isoxml.at(ns("//title[@language='zh']/title-main"))
        part = isoxml.at(ns("//title[@language='zh']/title-part"))
        partnumber = isoxml.at(ns("//id/project-number/@part"))
        main = compose_title(main, intro, part, partnumber)
        set_metadata(:doctitle, main)
      end

      def subtitle(isoxml, _out)
        intro = isoxml.at(ns("//title[@language='en']/title-intro"))
        main = isoxml.at(ns("//title[@language='en']/title-main"))
        part = isoxml.at(ns("//title[@language='en']/title-part"))
        partnumber = isoxml.at(ns("//id/project-number/@part"))
        main = compose_title(main, intro, part, partnumber)
        set_metadata(:docsubtitle, main)
      end


    end
  end
end

