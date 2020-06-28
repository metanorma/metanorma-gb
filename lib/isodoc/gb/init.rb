require "isodoc"
require_relative "metadata"
require_relative "xref"

module IsoDoc
  module Gb
    module Init
      def metadata_init(lang, script, labels)
        unless ["en", "zh"].include? lang
          lang = "zh"
          script = "Hans"
        end
        @meta = Metadata.new(lang, script, labels)
        @meta.set(:standardclassimg, @standardclassimg)
        @common&.meta = @meta
      end

      def xref_init(lang, script, klass, labels, options)
        @xrefs = Xref.new(lang, script, klass, labels, options)
      end
    end
  end
end

