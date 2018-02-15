require 'asciidoctor/extensions'
module Asciidoctor
  module Gb
    class ZhInlineMacro < Asciidoctor::Extensions::InlineMacroProcessor
      use_dsl
      named :zh
      parse_content_as :text
      using_format :short

      def process parent, target, attrs
        %{<string language="zh">#{Asciidoctor::Inline.new(parent, :quoted, attrs['text']).convert}</string>}
      end
    end

    class EnInlineMacro < Asciidoctor::Extensions::InlineMacroProcessor
      use_dsl
      named :deprecated
      parse_content_as :text
      using_format :short

      def process parent, target, attrs
        %{<string language="en">#{Asciidoctor::Inline.new(parent, :quoted, attrs['text']).convert}</string>}
      end
    end
  end
  end
