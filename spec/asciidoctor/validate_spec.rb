require "spec_helper"

RSpec.describe "warns when missing scope" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(/GB: no scope supplied, defaulting to National/).to_stderr }
      = Document title
      Author
      :docfile: test.adoc
      :mandate: guide
      :prefix T/BBB
      :nodoc:
      :novalid:

    INPUT
end

RSpec.describe "warns when missing prefix" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(/GB: no prefix supplied, defaulting to GB/).to_stderr }
      = Document title
      Author
      :docfile: test.adoc
      :mandate: guide
      :nodoc:
      :novalid:

    INPUT
end

RSpec.describe "warns when missing mandate" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(/GB: no mandate supplied, defaulting to mandatory/).to_stderr }
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:

    INPUT
end

RSpec.describe "warns when missing topic" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(/GB: no topic supplied, defaulting to basic/).to_stderr }
      = Document title
      Author
      :docfile: test.adoc
      :mandate: guide
      :nodoc:
      :novalid:

    INPUT
end

RSpec.describe "GB references is not a Non-ISO reference in Normative References" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.not_to output(%r{non-ISO/IEC reference not expected as normative}).to_stderr }
  #{VALIDATING_BLANK_HDR}

  [bibliography]
  == Normative References
  * [[[XYZ,NY 121]]] _Standard_
  INPUT
end

