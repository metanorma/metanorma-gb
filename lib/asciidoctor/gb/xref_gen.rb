require "isodoc"

module Asciidoctor
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class GbConvert < IsoDoc::Convert
      def format_ref(ref, isopub)
        return "ISO #{ref}" if isopub
        return "[#{ref}]" if /^\d+$/.match?(ref) && !/^\[.*\]$/.match?(ref)
        ref
      end

      def reference_names(ref)
        isopub = ref.at(ns(ISO_PUBLISHER_XPATH))
        docid = ref.at(ns("./docidentifier"))
        return ref_names(ref) unless docid
        date = ref.at(ns("./date[@type = 'published']"))
        reference = format_ref(docid.text, isopub)
        reference += ": #{date.text}" if date && isopub
        @anchors[ref["id"]] = { xref: reference }
      end
    end
  end
end
