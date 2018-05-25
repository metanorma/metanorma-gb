require "spec_helper"

RSpec.describe "does not warn when missing scope but scope inferred from prefix" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.not_to output(/GB: no scope supplied, defaulting to National/).to_stderr }
    = Document title
    Author
    :docfile: test.adoc
    :mandate: guide
    :prefix: T/BBB
    :nodoc:
    :novalid:

    INPUT
end

RSpec.describe "warns when missing scope and scope not inferred from prefix" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(/GB: no scope supplied, defaulting to National/).to_stderr }
    = Document title
    Author
    :docfile: test.adoc
    :mandate: guide
    :prefix: K/BBB
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

RSpec.describe "warns about improper social standard prefix" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{is improperly formatted for social standards}).to_stderr }
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :scope: social-group
  :prefix: ABCDEFG

  INPUT
end

RSpec.describe "warns about improper enterprise standard prefix" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{is improperly formatted for enterprise standards}).to_stderr }
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :scope: enterprise
  :prefix: AbCD

  INPUT
end

RSpec.describe "warns about improper sector standard prefix" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{is not a legal sector standard prefix}).to_stderr }
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :scope: sector
  :prefix: GJB

  INPUT
end

RSpec.describe "warns about improper local standard prefix" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{is not a legal local standard prefix}).to_stderr }
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :scope: local
  :prefix: GJB

  INPUT
end

RSpec.describe "warns about improper national standard prefix" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{is not a legal national standard prefix}).to_stderr }
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :scope: national
  :prefix: NY

  INPUT
end

RSpec.describe "warns about no issuer for enterprise standard" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{No issuer provided for enterprise standard}).to_stderr }
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :scope: enterprise
  :prefix: ABC

  INPUT
end

RSpec.describe "warns about English-only preferred" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{preferred term paddy has no Chinese counterpart}).to_stderr }
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:

  == Terms and Definitions

  === paddy
  [alt]#paddy#
  [deprecated]#paddy#

  INPUT
end

RSpec.describe "warns about English-only admitted" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{admitted term paddy has no Chinese counterpart}).to_stderr }
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:

  == Terms and Definitions

  === paddy
  [alt]#paddy#
  [deprecated]#paddy#

  INPUT
end

RSpec.describe "warns about English-only deprecates" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{deprecates term paddy has no Chinese counterpart}).to_stderr }
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:

  == Terms and Definitions

  === paddy
  [alt]#paddy#
  [deprecated]#paddy#

  INPUT
end


RSpec.describe "warns about Chinese-only preferred" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{preferred term XYZ paddy has no English counterpart}).to_stderr }
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:

  == Terms and Definitions

  === [zh]#XYZ paddy#
  alt:[[zh]#XYZ paddy#]
  deprecated:[[zh]#XYZ paddy#]

  INPUT
end

RSpec.describe "warns about Chinese-only admitted" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{admitted term XYZ paddy has no English counterpart}).to_stderr }
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:

  == Terms and Definitions

  === [zh]#XYZ paddy#
  alt:[[zh]#XYZ paddy#]
  deprecated:[[zh]#XYZ paddy#]

  INPUT
end

RSpec.describe "warns about Chinese-only deprecates" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{deprecates term XYZ paddy has no English counterpart}).to_stderr }
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:

  == Terms and Definitions

  === [zh]#XYZ paddy#
  alt:[[zh]#XYZ paddy#]
  deprecated:[[zh]#XYZ paddy#]

  INPUT
end

RSpec.describe "warns about no English title intro" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{No English Title Intro!}).to_stderr }
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :title-intro-zh: Title

  INPUT
end

RSpec.describe "warns about no Chinese title intro" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{No Chinese Title Intro!}).to_stderr }
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :title-intro-en: Title

  INPUT
end

RSpec.describe "warns about no English main title" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{No English Title!}).to_stderr }
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :title-main-zh: Title

  INPUT
end

RSpec.describe "warns about no Chinese main title" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{No Chinese Title!}).to_stderr }
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :title-main-en: Title

  INPUT
end

RSpec.describe "warns about no English title part" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{No English Title Part!}).to_stderr }
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :title-part-zh: Title

  INPUT
end

RSpec.describe "warns about no Chinese title part" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{No Chinese Title Part!}).to_stderr }
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :title-part-en: Title

  INPUT
end

RSpec.describe "warns about normative reference that is neither ISO nor GB" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.to output(%r{non-ISO/IEC reference not expected as normative}).to_stderr }
  #{VALIDATING_BLANK_HDR}

  [bibliography]
  == Normative References
  * [[[XYZ,IESO 121]]] _Standard_

  INPUT
end

RSpec.describe "does not warn about normative reference that is GB" do
  specify { expect { Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true) }.not_to output(%r{non-ISO/IEC reference not expected as normative}).to_stderr }
  #{VALIDATING_BLANK_HDR}

  [bibliography]
  == Normative References
  * [[[XYZ,GB/T 121]]] _Standard_

  INPUT
end


