require "metanorma/gb/converter"

module Asciidoctor
  # Deprecated alias: the GB compile converter moved to Metanorma::Gb.
  Gb = Metanorma::Gb
  deprecate_constant :Gb
end
