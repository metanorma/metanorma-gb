require "spec_helper"
require "fileutils"

RSpec.describe Asciidoctor::Gb do
  it "has a version number" do
    expect(Metanorma::Gb::VERSION).not_to be nil
  end

  #it "generates output for the Rice document" do
  #  FileUtils.rm_f %w(spec/examples/rice.doc spec/examples/rice.html)
  #  FileUtils.cd "spec/examples"
  #  Asciidoctor.convert_file "rice.adoc", {:attributes=>{"backend"=>"gb"}, :safe=>0, :header_footer=>true, :requires=>["metanorma-gb"], :failure_level=>4, :mkdirs=>true, :to_file=>nil}
  #  FileUtils.cd "../.."
  #  expect(File.exist?("spec/examples/rice.doc")).to be true
  #  expect(File.exist?("spec/examples/rice.html")).to be true
  #end

  it "processes a blank document" do
    expect(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)).to be_equivalent_to <<~"OUTPUT"
    #{ASCIIDOC_BLANK_HDR}
    INPUT
    #{BLANK_HDR}
<sections/>
</gb-standard>
    OUTPUT
  end

  it "uses Roman fonts" do
    FileUtils.rm_f "test.doc"
    Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Latn

    INPUT
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).to match(%r[\.Sourcecode[^{]+\{[^{]+font-family: "Courier New", monospace;]m)
    expect(html).to match(%r[body[^{]+\{[^{]+font-family: "Cambria", serif;]m)
    expect(html).to match(%r[\.h2Annex[^{]+\{[^{]+font-family: "Calibri", sans-serif;]m)
    expect(html).to match(%r[\.standard_class[^{]+\{[^{]+font-family: "Cambria", serif;]m)
  end

  it "uses Roman fonts, local scope" do
    FileUtils.rm_f "test.doc"
    Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Latn
      :scope: local

    INPUT
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).to match(%r[\.Sourcecode[^{]+\{[^{]+font-family: "Courier New", monospace;]m)
    expect(html).to match(%r[body[^{]+\{[^{]+font-family: "Cambria", serif;]m)
    expect(html).to match(%r[\.h2Annex[^{]+\{[^{]+font-family: "Calibri", sans-serif;]m)
    expect(html).to match(%r[\.standard_class[^{]+\{[^{]+font-family: "Calibri", sans-serif;]m)
  end

  it "uses default Chinese fonts" do
    FileUtils.rm_f "test.doc"
    Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :novalid:

    INPUT
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).to match(%r[\.Sourcecode[^{]+\{[^{]+font-family: "Courier New", monospace;]m)
    expect(html).to match(%r[body[^{]+\{[^{]+font-family: "SimSun", serif;]m)
    expect(html).to match(%r[\.h2Annex[^{]+\{[^{]+font-family: "SimHei", sans-serif;]m)
    expect(html).to match(%r[\.standard_class[^{]+\{[^{]+font-family: "SimSun", serif;]m)
  end

  it "uses Chinese fonts, local scope" do
    FileUtils.rm_f "test.doc"
    Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
      :scope: local

    INPUT
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).to match(%r[\.Sourcecode[^{]+\{[^{]+font-family: "Courier New", monospace;]m)
    expect(html).to match(%r[body[^{]+\{[^{]+font-family: "SimSun", serif;]m)
    expect(html).to match(%r[\.h2Annex[^{]+\{[^{]+font-family: "SimHei", sans-serif;]m)
    expect(html).to match(%r[\.standard_class[^{]+\{[^{]+font-family: "SimHei", sans-serif;]m)
  end

  it "uses specified fonts" do
    FileUtils.rm_f "test.doc"
    Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
      :body-font: Zapf Chancery
      :header-font: Comic Sans
      :monospace-font: Andale Mono
      :title-font: Symbol

    INPUT
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).to match(%r[\.Sourcecode[^{]+\{[^{]+font-family: Andale Mono;]m)
    expect(html).to match(%r[body[^{]+\{[^{]+font-family: Zapf Chancery;]m)
    expect(html).to match(%r[\.h2Annex[^{]+\{[^{]+font-family: Comic Sans;]m)
    expect(html).to match(%r[\.standard_class[^{]+\{[^{]+font-family: Symbol;]m)
  end

  it "uses specified images" do
    Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
      :standard-logo-img: spec/asciidoctor/examples/a.gif
      :standard-class-img: spec/asciidoctor/examples/b.gif
      :standard-issuer-img: spec/asciidoctor/examples/c.gif

    INPUT
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match %r{<div class="coverpage-logo-gb-img"><img class="logo" width="113" height="56" src="test_htmlimages/[^\.]+.gif" alt="GB" /></div>}
    expect(html).to match %r{<span class="coverpage-logo-text"><img class="logo" src="test_htmlimages/[^\.]+.gif" alt="&#x4E2D;&#x534E;&#x4EBA;&#x6C11;&#x5171;&#x548C;&#x56FD;&#x56FD;&#x5BB6;&#x6807;&#x51C6;" width="18" height="18" /></span>}
    expect(html).to match %r{<img class="logo" src="test_htmlimages/[^\.]+.gif" alt="&#x4E2D;&#x534E;&#x4EBA;&#x6C11;&#x5171;&#x548C;&#x56FD;&#x56FD;&#x5BB6;&#x8D28;&#x91CF;&#x76D1;&#x7763;&#x68C0;&#x9A8C;&#x68C0;&#x75AB;&#x603B;&#x5C40;,&#x4E2D;&#x56FD;&#x56FD;&#x5BB6;&#x6807;&#x51C6;&#x5316;&#x7BA1;&#x7406;&#x59D4;&#x5458;&#x4F1A;" width="18" height="18" />}
  end

  it "does contributor cleanup" do
    FileUtils.rm_f "test.doc"
    expect(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)).to be_equivalent_to <<~"OUTPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :nodoc:
      :language: en
      :script: Latn
      :scope: sector
      :prefix: NY
      :docnumber: 123
      :technical-committee-type: Governance
      :technical-committee: Technical


    INPUT
           <?xml version="1.0" encoding="UTF-8"?>
       <gb-standard xmlns="http://riboseinc.com/gbstandard">
       <bibdata type="standard">
         <title>

         </title>
         <title>

         </title>
         <docidentifier type="gb">NY 123</docidentifier>
         <docidentifier type="gb-structured">
           <project-number>NY 123</project-number>
         </docidentifier>
         <docnumber>123</docnumber>
         <contributor>
           <role type="author"/>
           <person>
             <name>
               <surname>Author</surname>
             </name>
           </person>
         </contributor><contributor><role type="technical-committee"/><organization><name>Technical</name></organization></contributor>
         <contributor>
           <role type="author"/>
           <organization>
             <name>GB</name>
           </organization>
         </contributor>
         <contributor>
           <role type="publisher"/>
           <organization>
             <name>GB</name>
           </organization>
         </contributor>
         <contributor>
           <role type="authority"/>
           <organization>
             <name>GB</name>
           </organization>
         </contributor>
         <contributor>
           <role type="proposer"/>
           <organization>
             <name>GB</name>
           </organization>
         </contributor>
         <contributor>
           <role type="issuer"/>
           <organization>
             <name>Ministry of Agriculture</name>
           </organization>
         </contributor>
         <language>en</language>
         <script>Latn</script>
         <status>
           <stage>60</stage>
           <substage>60</substage>
         </status>
         <copyright>
           <from>#{Date.today.year}</from>
           <owner>
             <organization>
               <name>Ministry of Agriculture</name>
             </organization>
           </owner>
         </copyright>
         <ext>
        <doctype>standard</doctype>
         <gbcommittee type="Governance">Technical</gbcommittee>
         <gbtype>
           <gbscope>sector</gbscope>
           <gbprefix>NY</gbprefix>
           <gbmandate>mandatory</gbmandate>
           <gbtopic>basic</gbtopic>
         </gbtype>
         </ext>
       </bibdata>
       <sections/>
       </gb-standard>
    OUTPUT
  end

    it "strips any initial boilerplate from terms and definitions" do
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true))).to be_equivalent_to <<~"OUTPUT"
      #{ASCIIDOC_BLANK_HDR}
      == Terms and Definitions

      I am boilerplate

      * So am I

      === Time

      This paragraph is extraneous
    INPUT
    #{BLANK_HDR}
              <sections>
         <terms id="_" obligation="normative"><title>Terms and definitions</title>
       <term id="_">
         <preferred language="zh"></preferred> <preferred language="en">Time</preferred>
         <definition><p id="_">This paragraph is extraneous</p></definition>
       </term></terms>
       </sections>
       </gb-standard>
    OUTPUT
  end

    it "does not strip any initial boilerplate from terms and definitions if keep-boilerplate attribute" do
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true))).to be_equivalent_to <<~"OUTPUT"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :keep-boilerplate:
      :language: en
      :script: Latn

      == Terms and Definitions

      I am boilerplate

      * So am I

      === Time

      This paragraph is extraneous
    INPUT
    #{BLANK_HDR}
              <sections>
         <terms id="_" obligation="normative"><title>Terms and definitions</title><p id="_">I am boilerplate</p>
       <ul id="_">
         <li>
           <p id="_">So am I</p>
         </li>
       </ul>
       <term id="_">
         <preferred language="zh"></preferred> <preferred language="en">Time</preferred>
         <definition><p id="_">This paragraph is extraneous</p></definition>
       </term></terms>
       </sections>
       </gb-standard>
    OUTPUT
  end

  it "processes ISO inline_quoted formatting" do
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true))).to be_equivalent_to <<~"OUTPUT"
      #{ASCIIDOC_BLANK_HDR}

      _emphasis_
      *strong*
      `monospace`
      "double quote"
      'single quote'
      super^script^
      sub~script~
      stem:[a_90]
      stem:[<mml:math><mml:msub xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"> <mml:mrow> <mml:mrow> <mml:mi mathvariant="bold-italic">F</mml:mi> </mml:mrow> </mml:mrow> <mml:mrow> <mml:mrow> <mml:mi mathvariant="bold-italic">&#x391;</mml:mi> </mml:mrow> </mml:mrow> </mml:msub> </mml:math>]
      [alt]#alt#
      [deprecated]#deprecated#
      [domain]#domain#
      [strike]#strike#
      [smallcap]#smallcap#
    INPUT
    #{BLANK_HDR}

       <sections>
         <em>emphasis</em>
       <strong>strong</strong>
       <tt>monospace</tt>
       “double quote”
       ‘single quote’
       super<sup>script</sup>
       sub<sub>script</sub>
       <stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><msub><mi>a</mi><mn>90</mn></msub></math></stem>
       <stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><msub> <mrow> <mrow> <mi mathvariant="bold-italic">F</mi> </mrow> </mrow> <mrow> <mrow> <mi mathvariant="bold-italic">Α</mi> </mrow> </mrow> </msub> </math></stem>
       <admitted language="zh"></admitted> <admitted language="en">alt</admitted>
       <deprecates language="zh"></deprecates> <deprecates language="en">deprecated</deprecates>
       <domain>domain</domain>
       <strike>strike</strike>
       <smallcap>smallcap</smallcap>
       </sections>
       </gb-standard>
    OUTPUT
  end

  it "processes GB inline_quoted formatting" do
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true))).to be_equivalent_to <<~"OUTPUT"
    #{ASCIIDOC_BLANK_HDR}

    [en]#en#
    [zh]#zh#
    [zh-Hans]#zh-Hans#
    [zh-Hant]#zh-Hant#
    INPUT
    #{BLANK_HDR}
       <sections>
       <p id="_"><string language="en">en</string>
       <string language="zh">zh</string>
       <string language="zh" script="Hans">zh-Hans</string>
       <string language="zh" script="Hant">zh-Hant</string></p>
       </sections>
       </gb-standard>
    OUTPUT
  end

  it "extracts localised strings by content" do
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true))).to be_equivalent_to <<~"OUTPUT"
    #{ASCIIDOC_BLANK_HDR}
    [deprecated]#deprecated 被取代#
    INPUT
    #{BLANK_HDR}
       <sections>
       <deprecates language="zh">被取代</deprecates> <deprecates language="en">deprecated</deprecates>
       </sections>
       </gb-standard>
    OUTPUT
  end

  it "extracts tagged localised strings" do
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true))).to be_equivalent_to <<~"OUTPUT"
      #{ASCIIDOC_BLANK_HDR}
      [bibliography]
      == Bibliography

      * [[[xiso123,XISO 123]]] _a_ [zh]#A# [en]#B#
    INPUT
       #{BLANK_HDR}
<sections>

       </sections><bibliography><references id="_" obligation="informative">
         <title>Bibliography</title>
         <bibitem id="xiso123">
         <em>a</em> <formattedref language="zh">A</formattedref> <formattedref language="en">B</formattedref>
         <docidentifier>XISO 123</docidentifier>
       </bibitem>
       </references></bibliography>
       </gb-standard>
    OUTPUT
  end

    it "fetches simple GB reference" do
    mock_gbbib_get_123
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true))).to be_equivalent_to <<~"OUTPUT"
      #{ISOBIB_BLANK_HDR}
      
      <<iso123>>

      [bibliography]
      == Normative References

      * [[[iso123,GB/T 20223-2006]]] _Standard_
    INPUT
      #{BLANK_HDR}
      <preface><foreword obligation="informative">
  <title>Foreword</title>
  <p id="_">
  <eref type="inline" bibitemid="iso123" citeas="GB/T 20223"/>
</p>
</foreword></preface>
      <sections>
             </sections><bibliography><references id="_" obligation="informative">
         <title>Normative References</title>
    #{GBT20223.sub(%{id="GB/T20223"}, %{id="iso123"})}
       </references></bibliography>
       </gb-standard>
    OUTPUT
    end

    private

    def mock_gbbib_get_123
      expect(Gbbib::GbBibliography).to receive(:get).with("GB/T 20223", "2006", {}) do
        IsoBibItem::XMLParser.from_xml(GBT20223)
      end
    end
end
