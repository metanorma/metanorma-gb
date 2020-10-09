require "spec_helper"

RSpec.describe Asciidoctor::Standoc do
  context "when xref_error.adoc compilation" do
    around do |example|
      FileUtils.rm_f "spec/assets/xref_error.err"
      example.run
      Dir["spec/assets/xref_error*"].each do |file|
        next if file.match?(/adoc$/)

        FileUtils.rm_f(file)
      end
    end

    it "generates error file" do
      expect do
        Metanorma::Compile
          .new
          .compile("spec/assets/xref_error.adoc", type: "gb")
      end.to(change { File.exist?("spec/assets/xref_error.err") }
              .from(false).to(true))
    end
  end

it  "Warns of illegal doctype" do
    FileUtils.rm_f "test.err"
    Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :no-isobib:
  :mandate: heaven
  :doctype: pizza

  text
  INPUT
  expect(File.read("test.err")).to include "heaven is not a recognised document type"
end

it  "Warns of illegal script" do
    FileUtils.rm_f "test.err"
    Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :no-isobib:
  :script: pizza

  text
  INPUT
  expect(File.read("test.err")).to include "pizza is not a recognised script"
end

it "does not warn when missing scope but scope inferred from prefix" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
    = Document title
    Author
    :docfile: test.adoc
    :mandate: guide
    :prefix: T/BBB
    :nodoc:

    INPUT
  if(File.exist?("test.err"))
  expect(File.read("test.err")).not_to include "GB: no scope supplied, defaulting to National"
  end
end

it "warns when missing scope and scope not inferred from prefix" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
    = Document title
    Author
    :docfile: test.adoc
    :mandate: guide
    :prefix: K/BBB
    :nodoc:

    INPUT
  expect(File.read("test.err")).to include "GB: no scope supplied, defaulting to National"
end

it "warns when missing prefix" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
    = Document title
    Author
    :docfile: test.adoc
    :mandate: guide
    :nodoc:

    INPUT
  expect(File.read("test.err")).to include "GB: no prefix supplied, defaulting to GB"
end

it "warns when missing mandate" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
    = Document title
    Author
    :docfile: test.adoc
    :nodoc:

    INPUT
  expect(File.read("test.err")).to include "GB: no mandate supplied, defaulting to mandatory"
end

it "warns when missing topic" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
    = Document title
    Author
    :docfile: test.adoc
    :mandate: guide
    :nodoc:

    INPUT
  expect(File.read("test.err")).to include "GB: no topic supplied, defaulting to basic"
end

it "GB references is not a Non-ISO reference in Normative References" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  #{VALIDATING_BLANK_HDR}

  [bibliography]
  == Normative References
  * [[[XYZ,NY 121]]] _Standard_
  INPUT
  expect(File.read("test.err")).not_to include "non-ISO/IEC reference not expected as normative"
end

it "warns about improper social standard prefix" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :scope: social-group
  :prefix: ABCDEFG

  INPUT
  expect(File.read("test.err")).to include "is improperly formatted for social standards"
end

it "warns about improper enterprise standard prefix" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :scope: enterprise
  :prefix: AbCD

  INPUT
  expect(File.read("test.err")).to include "is improperly formatted for enterprise standards"
end

it "warns about improper sector standard prefix" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :scope: sector
  :prefix: GJB

  INPUT
  expect(File.read("test.err")).to include "is not a legal sector standard prefix"
end

it "warns about improper local standard prefix" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :scope: local
  :prefix: GJB

  INPUT
  expect(File.read("test.err")).to include "is not a legal local standard prefix"
end

it "warns about improper national standard prefix" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :scope: national
  :prefix: NY

  INPUT
  expect(File.read("test.err")).to include "is not a legal national standard prefix"
end

it "warns about no issuer for enterprise standard" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :scope: enterprise
  :prefix: ABC

  INPUT
  expect(File.read("test.err")).to include "No issuer provided for enterprise standard"
end

it "warns about English-only preferred" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:

  == Terms and Definitions

  === paddy
  [alt]#paddy#
  [deprecated]#paddy#

  INPUT
  expect(File.read("test.err")).to include "preferred term paddy has no Chinese counterpart"
end

it "warns about English-only admitted" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:

  == Terms and Definitions

  === paddy
  [alt]#paddy#
  [deprecated]#paddy#

  INPUT
  expect(File.read("test.err")).to include "admitted term paddy has no Chinese counterpart"
end

it "warns about English-only deprecates" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:

  == Terms and Definitions

  === paddy
  [alt]#paddy#
  [deprecated]#paddy#

  INPUT
  expect(File.read("test.err")).to include "deprecates term paddy has no Chinese counterpart"
end


it "warns about Chinese-only preferred" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:

  == Terms and Definitions

  === [zh]#XYZ paddy#
  alt:[[zh]#XYZ paddy#]
  deprecated:[[zh]#XYZ paddy#]

  INPUT
  expect(File.read("test.err")).to include "preferred term XYZ paddy has no English counterpart"
end

it "warns about Chinese-only admitted" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:

  == Terms and Definitions

  === [zh]#XYZ paddy#
  alt:[[zh]#XYZ paddy#]
  deprecated:[[zh]#XYZ paddy#]

  INPUT
  expect(File.read("test.err")).to include "admitted term XYZ paddy has no English counterpart"
end

it "warns about Chinese-only deprecates" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:

  == Terms and Definitions

  === [zh]#XYZ paddy#
  alt:[[zh]#XYZ paddy#]
  deprecated:[[zh]#XYZ paddy#]

  INPUT
  expect(File.read("test.err")).to include "deprecates term XYZ paddy has no English counterpart"
end

it "warns about no English title intro" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :title-intro-zh: Title

  INPUT
  expect(File.read("test.err")).to include "No English Title Intro"
end

it "warns about no Chinese title intro" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :title-intro-en: Title

  INPUT
  expect(File.read("test.err")).to include "No Chinese Title Intro"
end

it "warns about no English main title" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :title-main-zh: Title

  INPUT
  expect(File.read("test.err")).to include "No English Title"
end

it "warns about no Chinese main title" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :title-main-en: Title

  INPUT
  expect(File.read("test.err")).to include "No Chinese Title"
end

it "warns about no English title part" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :title-part-zh: Title

  INPUT
  expect(File.read("test.err")).to include "No English Title Part"
end

it "warns about no Chinese title part" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :title-part-en: Title

  INPUT
  expect(File.read("test.err")).to include "No Chinese Title Part"
end

it "warns about normative reference that is neither ISO nor GB" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  #{VALIDATING_BLANK_HDR}

  [bibliography]
  == Normative References
  * [[[XYZ,IESO 121]]] _Standard_

  INPUT
  expect(File.read("test.err")).to include "non-ISO/IEC reference not expected as normative"
end

it "does not warn about normative reference that is GB" do
    FileUtils.rm_f "test.err"
  Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
  #{VALIDATING_BLANK_HDR}

  [bibliography]
  == Normative References
  * [[[XYZ,GB/T 121]]] _Standard_

  INPUT
  expect(File.read("test.err")).not_to include "non-ISO/IEC reference not expected as normative"
end

end
