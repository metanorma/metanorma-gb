require_relative "gbconvert"
require "gb_agencies"
require_relative "gbcleanup"
require_relative "metadata"
require_relative "gbhtmlrender"

module IsoDoc
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class HtmlConvert < IsoDoc::HtmlConvert
      def default_fonts(options)
        script = options[:script] || "Hans"
        b = options[:bodyfont] ||
          (script == "Hans" ? '"SimSun",serif' :
           script == "Latn" ? '"Cambria",serif' : '"SimSun",serif' )
        h = options[:headerfont] ||
          (script == "Hans" ? '"SimHei",sans-serif' :
           script == "Latn" ? '"Calibri",sans-serif' : '"SimHei",sans-serif' )
        m = options[:monospacefont] || '"Courier New",monospace'
        scope = options[:scope] || "national"
        t = options[:titlefont] ||
          (scope == "national" ? (script != "Hans" ? '"Cambria",serif' : '"SimSun",serif' ) :
           (script == "Hans" ? '"SimHei",sans-serif' : '"Calibri",sans-serif' ))
        "$bodyfont: #{b};\n$headerfont: #{h};\n$monospacefont: #{m};\n$titlefont: #{t};\n"
      end

      def initialize(options)
        @common = IsoDoc::Gb::Common.new(options)
        super
        if options[:compliant]
          @htmlstylesheet = generate_css(html_doc_path("htmlcompliantstyle.scss"), true, default_fonts(options))
          @htmlcoverpage = html_doc_path("html_compliant_gb_titlepage.html")
        else
          @htmlstylesheet = generate_css(html_doc_path("htmlstyle.scss"), true, default_fonts(options))
          #@htmlcoverpage = html_doc_path("html_gb_titlepage.html")
          @htmlcoverpage = html_doc_path("html_compliant_gb_titlepage.html")
        end
        @htmlintropage = html_doc_path("html_gb_intro.html")
        @scripts = html_doc_path("scripts.html")
        @lang = "zh"
        @script = "Hans"
      end

      def metadata_init(lang, script, labels)
        unless ["en", "zh"].include? lang
          lang = "zh"
          script = "Hans"
        end
        @meta = Metadata.new(lang, script, labels)
        @common = IsoDoc::Gb::Common.new(meta: @meta)
      end

      def cleanup(docxml)
        @cleanup = Cleanup.new(@script, @deprecated_lbl)
        super
        @cleanup.cleanup(docxml)
        docxml
      end

      def example_cleanup(docxml)
        super
        @cleanup.example_cleanup(docxml)
      end

      def html_doc_path(file)
        File.join(File.dirname(__FILE__), File.join("html", file))
      end

      def i18n_init(lang, script)
        super
        y = if lang == "en"
              YAML.load_file(File.join(File.dirname(__FILE__), "i18n-en.yaml"))
            elsif lang == "zh" && script == "Hans"
              YAML.load_file(File.join(File.dirname(__FILE__),
                                       "i18n-zh-Hans.yaml"))
            else
              YAML.load_file(File.join(File.dirname(__FILE__), "i18n-zh-Hans.yaml"))
            end
        @labels = @labels.merge(y)
      end
    end
  end
end
