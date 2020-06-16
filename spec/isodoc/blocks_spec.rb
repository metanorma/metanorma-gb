require "spec_helper"

RSpec.describe IsoDoc::Gb::HtmlConvert do
  it "processes unlabelled notes" do
                  expect(xmlpp(IsoDoc::Gb::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(/^.*<body/m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")

        <gb-standard xmlns="http://riboseinc.com/gbstandard">
                       <bibdata> <language>en</language> <script>Latn</script> </bibdata>
    <preface><foreword>
    <note id="A" keep-with-next="true" keep-lines-together="true">
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
</note>
    </foreword></preface>
    </gb-standard>
    INPUT
    #{HTML_HDR}
               <br/>
               <div>
                 <h1 class="ForewordTitle">Foreword&#160;</h1>
                 <table class="Note" keep-with-next="true" keep-lines-together="true">
                   <tr>
                     <td class="example_label" style="padding:2pt 2pt 2pt 2pt;vertical-align:top;">NOTE:</td>
                     <td style="vertical-align:top;" class="Note">
         <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
       </td>
                   </tr>
                 </table>
               </div>
               <p class="zzSTDTitle1">XXXX</p>
               <hr width="25%"/>
             </div>
           </body>
    OUTPUT
  end

  it "processes labelled notes" do
                  expect(xmlpp(IsoDoc::Gb::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(/^.*<body/m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
                       <bibdata> <language>en</language> <script>Latn</script> </bibdata>
    <preface><foreword>
    <note id="note1">
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
</note>
    </foreword></preface>
    </gb-standard>
INPUT
    #{HTML_HDR}
               <br/>
               <div>
                 <h1 class="ForewordTitle">Foreword&#160;</h1>
                 <table id="note1" class="Note">
                   <tr>
                     <td class="example_label" style="padding:2pt 2pt 2pt 2pt;vertical-align:top;">NOTE:</td>
                     <td style="vertical-align:top;" class="Note">
         <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
       </td>
                   </tr>
                 </table>
               </div>
               <p class="zzSTDTitle1">XXXX</p>
               <hr width="25%"/>
             </div>
           </body>
    OUTPUT
  end

  it "processes sequences of notes" do
                  expect(xmlpp(IsoDoc::Gb::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(/^.*<body/m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
                       <bibdata> <language>en</language> <script>Latn</script> </bibdata>
    <preface><foreword>
    <note id="note1">
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
</note>
    <note id="note2">
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
</note>
    </foreword></preface>
    </gb-standard>
INPUT
    #{HTML_HDR}
               <br/>
               <div>
                 <h1 class="ForewordTitle">Foreword&#160;</h1>
                 <table id="note1" class="Note">
                   <tr>
                     <td class="example_label" style="padding:2pt 2pt 2pt 2pt;vertical-align:top;">NOTE  1:</td>
                     <td style="vertical-align:top;" class="Note">
         <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
       </td>
                   </tr>
                 </table>
                 <table id="note2" class="Note">
                   <tr>
                     <td class="example_label" style="padding:2pt 2pt 2pt 2pt;vertical-align:top;">NOTE  2:</td>
                     <td style="vertical-align:top;" class="Note">
         <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
       </td>
                   </tr>
                 </table>
               </div>
               <p class="zzSTDTitle1">XXXX</p>
               <hr width="25%"/>
             </div>
           </body>
    OUTPUT
  end

  it "processes multi-para notes" do
                  expect(xmlpp(IsoDoc::Gb::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(/^.*<body/m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
                       <bibdata> <language>en</language> <script>Latn</script> </bibdata>
    <preface><foreword>
    <note>
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
</note>
    </foreword></preface>
    </gb-standard>
    INPUT
        #{HTML_HDR}
               <br/>
               <div>
                 <h1 class="ForewordTitle">Foreword&#160;</h1>
                 <table class="Note">
                   <tr>
                     <td class="example_label" style="padding:2pt 2pt 2pt 2pt;vertical-align:top;">NOTE:</td>
                     <td style="vertical-align:top;" class="Note">
         <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
         <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
       </td>
                   </tr>
                 </table>
               </div>
               <p class="zzSTDTitle1">XXXX</p>
               <hr width="25%"/>
             </div>
           </body>
    OUTPUT
  end

  it "processes non-para notes" do
                  expect(xmlpp(IsoDoc::Gb::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(/^.*<body/m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
                       <bibdata> <language>en</language> <script>Latn</script> </bibdata>
    <preface><foreword>
    <note>
    <dl>
    <dt>A</dt>
    <dd><p>B</p></dd>
    </dl>
    <ul>
    <li>C</li></ul>
</note>
    </foreword></preface>
    </gb-standard>
    INPUT
        #{HTML_HDR}
               <br/>
               <div>
                 <h1 class="ForewordTitle">Foreword&#160;</h1>
                 <table class="Note">
                   <tr>
                     <td class="example_label" style="padding:2pt 2pt 2pt 2pt;vertical-align:top;">NOTE:</td>
                     <td style="vertical-align:top;" class="Note">
           <dl><dt><p>A</p></dt><dd><p>B</p></dd></dl>
           <ul>
           <li>C</li></ul>
       </td>
                   </tr>
                 </table>
               </div>
               <p class="zzSTDTitle1">XXXX</p>
               <hr width="25%"/>
             </div>
           </body>
    OUTPUT
  end

  it "processes examples" do
                  expect(xmlpp(IsoDoc::Gb::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(/^.*<body/m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
                       <bibdata> <language>en</language> <script>Latn</script> </bibdata>
    <preface><foreword>
    <example id="samplecode">
    <name>Title</name>
  <p>Hello</p>
</example>
    </foreword></preface>
    </gb-standard>
    INPUT
        #{HTML_HDR}
                     <br/>
             <div>
               <h1 class="ForewordTitle">Foreword&#160;</h1>
               <div id="samplecode" class="example">
                 <p><span class="example_label">EXAMPLE:&#160;&#8212; Title</span>&#160; Hello</p>
               </div>
             </div>
             <p class="zzSTDTitle1">XXXX</p>
             <hr width="25%"/>
           </div>
         </body>
    OUTPUT
  end


  it "processes sequences of examples" do
                  expect(xmlpp(IsoDoc::Gb::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(/^.*<body/m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
                       <bibdata> <language>en</language> <script>Latn</script> </bibdata>
    <preface><foreword>
    <example id="samplecode">
  <quote>Hello</quote>
</example>
    <example id="samplecode2">
    <name>Title</name>
  <p>Hello</p>
</example>
    </foreword></preface>
    </gb-standard>
    INPUT
        #{HTML_HDR}
             <br/>
             <div>
               <h1 class="ForewordTitle">Foreword&#160;</h1>
               <div id="samplecode" class="example">
                 <p><span class="example_label">EXAMPLE  1:</span>&#160; </p>
                 <div class="Quote">Hello<p class="QuoteAttribution"/></div>
               </div>
               <div id="samplecode2" class="example">
                 <p><span class="example_label">EXAMPLE  2:&#160;&#8212; Title</span>&#160; Hello</p>
               </div>
             </div>
             <p class="zzSTDTitle1">XXXX</p>
             <hr width="25%"/>
           </div>
         </body>
    OUTPUT
  end

    it "processes examples (Word)" do
      expect(xmlpp(IsoDoc::Gb::WordConvert.new({}).convert("test", <<~"INPUT", true).gsub(/^.*<body/m, "<body").gsub(%r{<div class="WordSection3".*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
                       <bibdata> <language>en</language> <script>Latn</script> </bibdata>
    <preface><foreword>
    <example id="samplecode">
    <name>Title</name>
<p>Hello</p>
</example>
    </foreword></preface>
    </gb-standard>
    INPUT
          <body lang="EN-US" link="blue" vlink="#954F72">
           <div class="WordSection1">
             <p>&#160;</p>
           </div>
           <p>
             <br clear="all" class="section"/>
           </p>
           <div class="WordSection2">
             <p>
               <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
             </p>
             <div>
               <h1 class="ForewordTitle">Foreword&#160;</h1>
               <div id="samplecode" class="example">
                 <p><span class="example_label">EXAMPLE:&#160;&#8212; Title</span><span style="mso-tab-count:1">&#160; </span>Hello</p>
               </div>
             </div>
             <p>&#160;</p>
           </div>
           <p>
             <br clear="all" class="section"/>
           </p>
           </body>
    OUTPUT
  end


  it "processes sequences of examples (Word)" do
                  expect(xmlpp(IsoDoc::Gb::WordConvert.new({}).convert("test", <<~"INPUT", true).gsub(/^.*<body/m, "<body").gsub(%r{<div class="WordSection3">.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
                       <bibdata> <language>en</language> <script>Latn</script> </bibdata>
    <preface><foreword>
    <example id="samplecode">
  <quote>Hello</quote>
</example>
    <example id="samplecode2">
    <name>Title</name>
  <p>Hello</p>
</example>
    </foreword></preface>
    </gb-standard>
    INPUT
           <body lang="EN-US" link="blue" vlink="#954F72">
           <div class="WordSection1">
             <p>&#160;</p>
           </div>
           <p>
             <br clear="all" class="section"/>
           </p>
           <div class="WordSection2">
             <p>
               <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
             </p>
             <div>
               <h1 class="ForewordTitle">Foreword&#160;</h1>
               <div id="samplecode" class="example">
                 <p><span class="example_label">EXAMPLE  1:</span><span style="mso-tab-count:1">&#160; </span></p>
                 <div class="Quote">Hello<p class="QuoteAttribution"/></div>
               </div>
               <div id="samplecode2" class="example">
                 <p><span class="example_label">EXAMPLE  2:&#160;&#8212; Title</span><span style="mso-tab-count:1">&#160; </span>Hello</p>
               </div>
             </div>
             <p>&#160;</p>
           </div>
           <p>
             <br clear="all" class="section"/>
           </p>
           </body>
    OUTPUT
  end

  it "processes formulae" do
                  expect(xmlpp(IsoDoc::Gb::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(/^.*<body/m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
                       <bibdata> <language>en</language> <script>Latn</script> </bibdata>
    <preface><foreword>
    <formula id="_be9158af-7e93-4ee2-90c5-26d31c181934">
  <stem type="AsciiMath">r = 1 %</stem>
<dl id="_e4fe94fe-1cde-49d9-b1ad-743293b7e21d">
  <dt>
    <stem type="AsciiMath">r</stem>
  </dt>
  <dd>
    <p id="_1b99995d-ff03-40f5-8f2e-ab9665a69b77">is the repeatability limit.</p>
  </dd>
</dl></formula>
    </foreword></preface>
    </gb-standard>
    INPUT
        #{HTML_HDR}
               <br/>
               <div>
                 <h1 class="ForewordTitle">Foreword&#160;</h1>
                 <div id="_be9158af-7e93-4ee2-90c5-26d31c181934" class="formula">&#160; <span class="stem">(#(r = 1 %)#)</span>&#160; (1)</div>
                 <p style='page-break-after:avoid;'>where</p>
<table class='formula_dl'>
                   <tr>
                     <td style="vertical-align:top;text-align:left;">
           <span class="stem">(#(r)#)</span>
         </td>
                     <td style="vertical-align:top;">&#8212;</td>
                     <td style="vertical-align:top;">
           <p id="_1b99995d-ff03-40f5-8f2e-ab9665a69b77">is the repeatability limit.</p>
         </td>
                   </tr>
                 </table>
               </div>
               <p class="zzSTDTitle1">XXXX</p>
               <hr width="25%"/>
             </div>
           </body>
    OUTPUT
  end

    it "processes term notes" do
                  expect(xmlpp(IsoDoc::Gb::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(/^.*<body/m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
                       <bibdata> <language>en</language> <script>Latn</script> </bibdata>
    <sections>
    <terms id="_terms_and_definitions" obligation="normative"><title>Terms and Definitions</title>

<term id="paddy"><preferred>paddy</preferred><admitted>paddy rice</admitted>
<definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></definition>
<termnote id="_671a1994-4783-40d0-bc81-987d06ffb74e">
  <p id="_19830f33-e46c-42cc-94ca-a5ef101132d5">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
</termnote>
<termnote id="_671a1994-4783-40d0-bc81-987d06ffb74f">
<ul><li>A</li></ul>
  <p id="_19830f33-e46c-42cc-94ca-a5ef101132d5">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
</termnote>
</term>
</terms>
</sections>
</gb-standard>
    INPUT
        #{HTML_HDR}
               <p class="zzSTDTitle1">XXXX</p>
               <div id="_terms_and_definitions"><h1>1.&#12288;Terms and Definitions</h1>
       <p class="TermNum" id="paddy">1.1.</p><p class="Terms" style="text-align:left;">paddy</p><p class="AltTerms" style="text-align:left;">paddy rice</p>
       <p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p>
       <table id="_671a1994-4783-40d0-bc81-987d06ffb74e" class="Note"><tr><td class="example_label" style="padding:2pt 2pt 2pt 2pt;vertical-align:top;">Note 1 to entry:</td><td style="vertical-align:top;" class="Note">
         <p id="_19830f33-e46c-42cc-94ca-a5ef101132d5">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
       </td></tr></table>
       <table id="_671a1994-4783-40d0-bc81-987d06ffb74f" class="Note"><tr><td class="example_label" style="padding:2pt 2pt 2pt 2pt;vertical-align:top;">Note 2 to entry:</td><td style="vertical-align:top;" class="Note">
       <ul><li>A</li></ul>
         <p id="_19830f33-e46c-42cc-94ca-a5ef101132d5">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
       </td></tr></table>
       </div>
               <hr width="25%"/>
             </div>
           </body>
OUTPUT
    end
end
