require "isodoc"
require_relative "metadata"
require_relative "xref"
require_relative "i18n"

module IsoDoc
  module Gb
    module Init
      def metadata_init(lang, script, locale, labels)
        unless ["en", "zh"].include? lang
          lang = "zh"
          script = "Hans"
        end
        @meta = Metadata.new(lang, script, locale, labels)
        @meta.set(:standardclassimg, @standardclassimg)
        @common&.meta = @meta
      end

      def xref_init(lang, script, klass, labels, options)
        @xrefs = Xref.new(lang, script, HtmlConvert.new(language: lang, script: script), labels, options)
      end

      def i18n_init(lang, script, locale, i18nyaml = nil)
        @i18n = I18n.new(lang, script, locale: locale,
                                        i18nyaml: i18nyaml || @i18nyaml)
      end

      def bibrenderer(options = {})
        ::Relaton::Render::Iso::General.new(options
          .merge(language: @lang, script: @script, i18nhash: @i18n.get))
      end

      def amd?(_docxml)
        %w(amendment technical-corrigendum).include? @doctype
      end

      def clausedelim
        ""
      end
    end
  end
end

