require "asciidoctor" unless defined? Asciidoctor::Converter
require_relative "asciidoctor/gb/converter"
require_relative "metanorma/gb/version"
require "isodoc/gb/common"
require "isodoc/gb/html_convert"
require "isodoc/gb/word_convert"
require "isodoc/gb/pdf_convert"

if defined? Metanorma
  require_relative "metanorma/gb"
  Metanorma::Registry.instance.register(Metanorma::Gb::Processor)
end
