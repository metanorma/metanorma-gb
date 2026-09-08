# frozen_string_literal: true

require "metanorma/iso/html"

module Metanorma
  module Gb
    # HTML format slice for the flavor: the renderer, registered with
    # the harness from gb/document.rb. Renders iso-style; the GB root
    # uses the ISO section classes, which the ISO renderer registers.
    module Html
      autoload :Renderer, "#{__dir__}/html/renderer"
    end
  end
end
