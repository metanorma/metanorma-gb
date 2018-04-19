require "spec_helper"

RSpec.describe "warns when missing a title" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(/GB: no scope supplied, defaulting to National/).to_stderr }
      = Document title
      Author
      :docfile: test.adoc
      :mandate: guide
      :prefix T/BBB
      :nodoc:
      :novalid:

    INPUT

  INPUT
end
end
