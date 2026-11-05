require "relaton/render"

module Metanorma
  module Gb
    # Subclasses the consolidated relaton render engine directly, in this
    # gem's own namespace. The former parent, isodoc's
    # Relaton::Render::IsoDoc::General, only defaulted the style file to
    # its own styles/isodoc.yml — that default ships here verbatim, so
    # gb's citation rendering is unchanged.
    class General < ::Relaton::Render::General
      STYLE_PATH = File.join(__dir__, "styles/isodoc.yml")

      def initialize(options = {})
        options[:style] ||= STYLE_PATH
        super
      end
    end
  end
end
