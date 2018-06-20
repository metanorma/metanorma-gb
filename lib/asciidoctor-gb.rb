require "asciidoctor" unless defined? Asciidoctor::Converter
require_relative "asciidoctor/gb/converter"
require_relative "asciidoctor/gb/version"
require "isodoc/gb/gbconvert"
require "isodoc/gb/gbhtmlconvert"
require "isodoc/gb/gbwordconvert"

if defined? Metanorma
  require_relative "metanorma/gb"
  Metanorma::Registry.instance.register(Metanorma::Gb::Processor)
end
