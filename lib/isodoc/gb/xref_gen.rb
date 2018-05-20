require "isodoc"

module Isodoc
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class Convert < IsoDoc::Convert
      def reference_names(ref)
      isopub = ref.at(ns(ISO_PUBLISHER_XPATH))
      docid = ref.at(ns("./docidentifier"))
      date = ref.at(ns("./date[@type = 'published']"))
      reference = format_ref(docid.text, isopub, date)
      @anchors[ref["id"]] = { xref: reference }
      end
    end
  end
end
