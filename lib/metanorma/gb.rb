require_relative "./gb/processor"

module Metanorma
  module Gb
    autoload :Registers, "metanorma/gb/registers"
    autoload :General, "metanorma/gb/general"
  end
end

require "metanorma/gb/document"
