require_relative "init"
require "isodoc"

module IsoDoc
  module Gb
    class PresentationXMLConvert < IsoDoc::Iso::PresentationXMLConvert
      include Init
    end
  end
end

