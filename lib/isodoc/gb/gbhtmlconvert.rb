require_relative "gbbaseconvert"
require_relative "gbhtmlrender"
require "isodoc"

module IsoDoc
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class HtmlConvert < IsoDoc::HtmlConvert
      def initialize(options)
        @common = IsoDoc::Gb::Common.new(options)
        @standardclassimg = options[:standardclassimg]
        @libdir = File.dirname(__FILE__)
        super
        @lang = "zh"
        @script = "Hans"
      end

      def default_fonts(options)
        script = options[:script] || "Hans"
        scope = options[:scope] || "national"
        {
          bodyfont: (script == "Hans" ? '"SimSun",serif' : '"Cambria",serif'),
          headerfont: (script == "Hans" ? '"SimHei",sans-serif' : '"Calibri",sans-serif'),
          monospacefont: '"Courier New",monospace',
          titlefont: (scope == "national" ? (script != "Hans" ? '"Cambria",serif' : '"SimSun",serif' ) :
           (script == "Hans" ? '"SimHei",sans-serif' : '"Calibri",sans-serif' ))
        }
      end

      def default_file_locations(options)
        {
          htmlstylesheet: options[:compliant] ? html_doc_path("htmlcompliantstyle.scss") : html_doc_path("htmlstyle.scss"),
          htmlcoverpage: html_doc_path("html_compliant_gb_titlepage.html"),
          htmlintropage: html_doc_path("html_gb_intro.html"),
          scripts: html_doc_path("scripts.html"),
        }
      end

      include BaseConvert
    end
  end
end
