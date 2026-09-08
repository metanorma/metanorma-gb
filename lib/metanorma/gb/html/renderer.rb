# frozen_string_literal: true

module Metanorma
  module Gb
    module Html
      # GB documents render iso-style; the GB root uses the ISO
      # section classes the parent renderer already registers — only
      # the root itself needs dispatch (exact-class, OGC pattern).
      class Renderer < Metanorma::Iso::Html::Renderer
        register_render "Metanorma::Gb::Document::Root", :render_document
      end
    end
  end
end
