require "spec_helper"

RSpec.describe Asciidoctor::Gb do
  it "processes metadata" do
    expect(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)).to be_equivalent_to <<~"OUTPUT"
      = Document title
      Author
      :docfile: test.adoc
      :mandate: mandatory
      :author: Fred Bloggs, Joe Schmoe
      :copyright-year: 1999
      :technical-committee-type: Governance
      :technical-committee: Technical
      :iso-standard: ISO 1012
      :obsoletes: GB/T 134, Source Frequency Regulation
      :obsoletes-parts: Section 3-5
      :scope: national
      :nodoc:
      :novalid:

    INPUT
<sections/>
</gb-standard>
    OUTPUT
  end

  it "processes metadata" do
    expect(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)).to be_equivalent_to <<~"OUTPUT"
      = Document title
      Author
      :docfile: test.adoc
      :mandate: recommendation
      :iso-standard: ISO 1012, Televisual Frequencies
      :equivalence: nonequivalent
      :prefix T/AAA
      :nodoc:
      :novalid:

    INPUT
<sections/>
</gb-standard>
    OUTPUT
  end

  it "processes metadata" do
    expect(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)).to be_equivalent_to <<~"OUTPUT"
      = Document title
      Author
      :docfile: test.adoc
      :mandate: guide
      :prefix T/BBB
      :nodoc:
      :novalid:

    INPUT
<sections/>
</gb-standard>
    OUTPUT
  end



end
