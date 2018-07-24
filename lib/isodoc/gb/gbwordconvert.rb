require "isodoc"
require_relative "gbconvert"
require_relative "gbcleanup"
require "gb_agencies"
require_relative "metadata"
require_relative "gbwordrender"

module IsoDoc
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation

    class WordConvert < IsoDoc::WordConvert
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

      def metadata_init(lang, script, labels)
        @meta = Metadata.new(lang, script, labels)
        @common = IsoDoc::Gb::Common.new(meta: @meta)
      end

      def html_doc_path(file)
        File.join(File.dirname(__FILE__), File.join("html", file))
      end

      def initialize(options)
        @common = IsoDoc::Gb::Common.new(options)
        super
        @wordstylesheet = generate_css(html_doc_path("wordstyle.scss"), false, default_fonts(options))
        @standardstylesheet = generate_css(html_doc_path("gb.scss"), false, default_fonts(options))
        @header = html_doc_path("header.html")
        @wordcoverpage = html_doc_path("word_gb_titlepage.html")
        @wordintropage = html_doc_path("word_gb_intro.html")
        @ulstyle = "l7"
        @olstyle = "l10"
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

      ENDLINE = <<~END.freeze
      <v:line id="_x0000_s1026"
 alt="" style='position:absolute;left:0;text-align:left;z-index:251662848;
 mso-wrap-edited:f;mso-width-percent:0;mso-height-percent:0;
 mso-width-percent:0;mso-height-percent:0'
 from="6.375cm,20.95pt" to="10.625cm,20.95pt"
 strokeweight="1.5pt"/>
      END

      def end_line(_isoxml, out)
        out.parent.add_child(ENDLINE)
      end

      def generate_header(filename, dir)
        return unless @header
        template = Liquid::Template.parse(File.read(@header, encoding: "UTF-8"))
        meta = @meta.get
        meta[:filename] = filename
        params = meta.map { |k, v| [k.to_s, v] }.to_h
        File.open("header.html", "w") { |f| f.write(template.render(params)) }
        system "cp #{@common.fileloc(File.join('html', 'blank.png'))} blank.png"
        @files_to_delete << "blank.png"
        @files_to_delete << "header.html"
        "header.html"
      end

      def header_strip(h)
        h = h.to_s.gsub(%r{<br/>}, " ").sub(/<\/?h[12][^>]*>/, "")
        h1 = to_xhtml_fragment(h.dup)
        h1.traverse do |x|
          x.replace(" ") if x.name == "span" &&
            /mso-tab-count/.match?(x["style"])
          x.remove if x.name == "span" && x["class"] == "MsoCommentReference"
          x.remove if x.name == "a" && x["epub:type"] == "footnote"
          x.replace(x.children) if x.name == "a"
        end
        from_xhtml(h1)
      end

      def word_cleanup(docxml)
        word_preface(docxml)
        word_annex_cleanup(docxml)
        @cleanup.title_cleanup(docxml.at('//div[@class="WordSection2"]'))
        docxml
      end

      def html_doc_path(file)
        File.join(File.dirname(__FILE__), File.join("html", file))
      end
    end
  end
end
