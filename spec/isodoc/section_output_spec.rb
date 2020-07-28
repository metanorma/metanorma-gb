require "spec_helper"

RSpec.describe IsoDoc::Gb::HtmlConvert do
    it "processes clause names" do
          expect(xmlpp(IsoDoc::Gb::PresentationXMLConvert.new({}).convert("test", <<~"INPUT", true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
        <bibdata>
        <language>en</language>
        <script>Latn</script>
        </bibdata>
               <sections>
               <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
         <title>Introduction</title>
       </clause>
       <clause id="O" inline-header="true" obligation="normative">
         <title>Clause 4.2</title>
       </clause></clause>
        </sections>
    </gb-standard>
    INPUT
           <gb-standard xmlns='http://riboseinc.com/gbstandard'>
  <bibdata>
    <language>en</language>
    <script>Latn</script>
  </bibdata>
  <sections>
    <clause id='M' inline-header='false' obligation='normative'>
      <title depth='1'>1<tab/>Clause 4</title>
      <clause id='N' inline-header='false' obligation='normative'>
        <title depth='2'>1.1<tab/>Introduction</title>
      </clause>
      <clause id='O' inline-header='true' obligation='normative'>
        <title depth='2'>1.2<tab/>Clause 4.2</title>
      </clause>
    </clause>
  </sections>
</gb-standard>

    OUTPUT
  end

        it "processes clause names, suppressing heading numbers" do
          expect(xmlpp(IsoDoc::Gb::PresentationXMLConvert.new({suppressheadingnumbers: true}).convert("test", <<~"INPUT", true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
        <bibdata>
        <language>en</language>
        <script>Latn</script>
        </bibdata>
               <sections>
               <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
         <title>Introduction</title>
       </clause>
       <clause id="O" inline-header="true" obligation="normative">
         <title>Clause 4.2</title>
       </clause></clause>
        </sections>
    </gb-standard>
    INPUT
           <gb-standard xmlns='http://riboseinc.com/gbstandard'>
  <bibdata>
    <language>en</language>
    <script>Latn</script>
  </bibdata>
  <sections>
    <clause id='M' inline-header='false' obligation='normative'>
      <title depth='1'>Clause 4</title>
      <clause id='N' inline-header='false' obligation='normative'>
        <title depth='2'>Introduction</title>
      </clause>
      <clause id='O' inline-header='true' obligation='normative'>
        <title depth='2'>Clause 4.2</title>
      </clause>
    </clause>
  </sections>
</gb-standard>
    OUTPUT
  end

        it "processes annex names" do
          expect(xmlpp(IsoDoc::Gb::PresentationXMLConvert.new({}).convert("test", <<~"INPUT", true))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
        <bibdata>
        <language>en</language>
        <script>Latn</script>
        </bibdata>
        <annex id="P" inline-header="false" obligation="normative">
         <title>Annex</title>
        </annex> 
    </gb-standard>
    INPUT
    <gb-standard xmlns='http://riboseinc.com/gbstandard'>
  <bibdata>
    <language>en</language>
    <script>Latn</script>
  </bibdata>
  <annex id='P' inline-header='false' obligation='normative'>
    <title>
      <strong>Annex A</strong>
      <br/>
      (normative)
      <br/>
      <br/>
      Annex
    </title>
  </annex>
</gb-standard>
    OUTPUT
  end

end
