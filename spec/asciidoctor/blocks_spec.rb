require "spec_helper"

RSpec.describe Asciidoctor::Gb::GbConvert do
  it "processes unlabelled notes" do
    expect(Asciidoctor::Gb::GbConvert.new({}).convert_file(<<~"INPUT", "test", true)).to be_equivalent_to <<~"OUTPUT"
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
    <preface><foreword>
    <note>
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
</note>
    </foreword></preface>
    </gb-standard>
    INPUT
           <html xmlns:epub="http://www.idpf.org/2007/ops">
         <head>
           <title>test</title>
           <body lang="EN-US" link="blue" vlink="#954F72">
             <div class="WordSection1">
               <p>&#160;</p>
             </div>
             <br/>
             <div class="WordSection2">
               <br/>
               <div>
                 <h1 class="ForewordTitle">Foreword&#160;</h1>
                 <table class="Note">
                   <tr>
                     <td valign="top" class="example_label" style="padding:2pt 2pt 2pt 2pt">NOTE:</td>
                     <td valign="top" class="Note">
         <p class="Note" id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
       </td>
                   </tr>
                 </table>
               </div>
               <p>&#160;</p>
             </div>
             <br/>
             <div class="WordSection3">
               <p class="zzSTDTitle1">XXXX</p>
               <hr width="25%"/>
             </div>
           </body>
         </head>
       </html>
    OUTPUT
  end

  it "processes labelled notes" do
    expect(Asciidoctor::Gb::GbConvert.new({}).convert_file(<<~"INPUT", "test", true)).to be_equivalent_to <<~"OUTPUT"
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
    <preface><foreword>
    <note id="note1">
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
</note>
    </foreword></preface>
    </gb-standard>
INPUT
       <html xmlns:epub="http://www.idpf.org/2007/ops">
         <head>
           <title>test</title>
           <body lang="EN-US" link="blue" vlink="#954F72">
             <div class="WordSection1">
               <p>&#160;</p>
             </div>
             <br/>
             <div class="WordSection2">
               <br/>
               <div>
                 <h1 class="ForewordTitle">Foreword&#160;</h1>
                 <table id="note1" class="Note">
                   <tr>
                     <td valign="top" class="example_label" style="padding:2pt 2pt 2pt 2pt">NOTE:</td>
                     <td valign="top" class="Note">
         <p class="Note" id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
       </td>
                   </tr>
                 </table>
               </div>
               <p>&#160;</p>
             </div>
             <br/>
             <div class="WordSection3">
               <p class="zzSTDTitle1">XXXX</p>
               <hr width="25%"/>
             </div>
           </body>
         </head>
       </html>
    OUTPUT
  end

  it "processes sequences of notes" do
    expect(Asciidoctor::Gb::GbConvert.new({}).convert_file(<<~"INPUT", "test", true)).to be_equivalent_to <<~"OUTPUT"
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
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
       <html xmlns:epub="http://www.idpf.org/2007/ops">
         <head>
           <title>test</title>
           <body lang="EN-US" link="blue" vlink="#954F72">
             <div class="WordSection1">
               <p>&#160;</p>
             </div>
             <br/>
             <div class="WordSection2">
               <br/>
               <div>
                 <h1 class="ForewordTitle">Foreword&#160;</h1>
                 <table id="note1" class="Note">
                   <tr>
                     <td valign="top" class="example_label" style="padding:2pt 2pt 2pt 2pt">NOTE  1:</td>
                     <td valign="top" class="Note">
         <p class="Note" id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
       </td>
                   </tr>
                 </table>
                 <table id="note2" class="Note">
                   <tr>
                     <td valign="top" class="example_label" style="padding:2pt 2pt 2pt 2pt">NOTE  2:</td>
                     <td valign="top" class="Note">
         <p class="Note" id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
       </td>
                   </tr>
                 </table>
               </div>
               <p>&#160;</p>
             </div>
             <br/>
             <div class="WordSection3">
               <p class="zzSTDTitle1">XXXX</p>
               <hr width="25%"/>
             </div>
           </body>
         </head>
       </html>
    OUTPUT
  end

  it "processes multi-para notes" do
    expect(Asciidoctor::Gb::GbConvert.new({}).convert_file(<<~"INPUT", "test", true)).to be_equivalent_to <<~"OUTPUT"
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
    <preface><foreword>
    <note>
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
</note>
    </foreword></preface>
    </gb-standard>
    INPUT
           <html xmlns:epub="http://www.idpf.org/2007/ops">
         <head>
           <title>test</title>
           <body lang="EN-US" link="blue" vlink="#954F72">
             <div class="WordSection1">
               <p>&#160;</p>
             </div>
             <br/>
             <div class="WordSection2">
               <br/>
               <div>
                 <h1 class="ForewordTitle">Foreword&#160;</h1>
                 <table class="Note">
                   <tr>
                     <td valign="top" class="example_label" style="padding:2pt 2pt 2pt 2pt">NOTE:</td>
                     <td valign="top" class="Note">
         <p class="Note" id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
         <p class="Note" id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
       </td>
                   </tr>
                 </table>
               </div>
               <p>&#160;</p>
             </div>
             <br/>
             <div class="WordSection3">
               <p class="zzSTDTitle1">XXXX</p>
               <hr width="25%"/>
             </div>
           </body>
         </head>
       </html>
    OUTPUT
  end

  it "processes non-para notes" do
    expect(Asciidoctor::Gb::GbConvert.new({}).convert_file(<<~"INPUT", "test", true)).to be_equivalent_to <<~"OUTPUT"
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
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
       <html xmlns:epub="http://www.idpf.org/2007/ops">
         <head>
           <title>test</title>
           <body lang="EN-US" link="blue" vlink="#954F72">
             <div class="WordSection1">
               <p>&#160;</p>
             </div>
             <br/>
             <div class="WordSection2">
               <br/>
               <div>
                 <h1 class="ForewordTitle">Foreword&#160;</h1>
                 <table class="Note">
                   <tr>
                     <td valign="top" class="example_label" style="padding:2pt 2pt 2pt 2pt">NOTE:</td>
                     <td valign="top" class="Note">
           <dl><dt><p class="Note">A</p></dt><dd><p class="Note">B</p></dd></dl>
           <ul>
           <li>C</li></ul>
       </td>
                   </tr>
                 </table>
               </div>
               <p>&#160;</p>
             </div>
             <br/>
             <div class="WordSection3">
               <p class="zzSTDTitle1">XXXX</p>
               <hr width="25%"/>
             </div>
           </body>
         </head>
       </html>
    OUTPUT
  end

  it "processes examples" do
    expect(Asciidoctor::Gb::GbConvert.new({}).convert_file(<<~"INPUT", "test", true)).to be_equivalent_to <<~"OUTPUT"
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
    <preface><foreword>
    <example id="samplecode">
  <p>Hello</p>
</example>
    </foreword></preface>
    </gb-standard>
    INPUT
           <html xmlns:epub="http://www.idpf.org/2007/ops">
         <head>
           <title>test</title>
           <body lang="EN-US" link="blue" vlink="#954F72">
             <div class="WordSection1">
               <p>&#160;</p>
             </div>
             <br/>
             <div class="WordSection2">
               <br/>
               <div>
                 <h1 class="ForewordTitle">Foreword&#160;</h1>
                 <table id="samplecode" class="example">
                   <tr>
                     <td valign="top" class="example_label" style="padding:2pt 2pt 2pt 2pt">EXAMPLE:</td>
                     <td valign="top">
         <p>Hello</p>
       </td>
                   </tr>
                 </table>
               </div>
               <p>&#160;</p>
             </div>
             <br/>
             <div class="WordSection3">
               <p class="zzSTDTitle1">XXXX</p>
               <hr width="25%"/>
             </div>
           </body>
         </head>
       </html>
    OUTPUT
  end


  it "processes sequences of examples" do
    expect(Asciidoctor::Gb::GbConvert.new({}).convert_file(<<~"INPUT", "test", true)).to be_equivalent_to <<~"OUTPUT"
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
    <preface><foreword>
    <example id="samplecode">
  <p>Hello</p>
</example>
    <example id="samplecode2>
  <p>Hello</p>
</example>
    </foreword></preface>
    </gb-standard>
    INPUT
           <html xmlns:epub="http://www.idpf.org/2007/ops">
         <head>
           <title>test</title>
           <body lang="EN-US" link="blue" vlink="#954F72">
             <div class="WordSection1">
               <p>&#160;</p>
             </div>
             <br/>
             <div class="WordSection2">
               <br/>
               <div>
                 <h1 class="ForewordTitle">Foreword&#160;</h1>
                 <table id="samplecode" class="example">
                   <tr>
                     <td valign="top" class="example_label" style="padding:2pt 2pt 2pt 2pt">EXAMPLE  1:</td>
                     <td valign="top">
         <p>Hello</p>
       </td>
                   </tr>
                 </table>
                 <table id="samplecode2&gt;   " class="example">
                   <tr>
                     <td valign="top" class="example_label" style="padding:2pt 2pt 2pt 2pt">EXAMPLE  2:</td>
                     <td valign="top"/>
                   </tr>
                 </table>
                 <p>Hello</p>
               </div>
               <p>&#160;</p>
             </div>
             <br/>
             <div class="WordSection3">
               <p class="zzSTDTitle1">XXXX</p>
               <hr width="25%"/>
             </div>
           </body>
         </head>
       </html>
    OUTPUT
  end

  it "processes formulae" do
    expect(Asciidoctor::Gb::GbConvert.new({}).convert_file(<<~"INPUT", "test", true)).to be_equivalent_to <<~"OUTPUT"
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
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
           <html xmlns:epub="http://www.idpf.org/2007/ops">
         <head>
           <title>test</title>
           <body lang="EN-US" link="blue" vlink="#954F72">
             <div class="WordSection1">
               <p>&#160;</p>
             </div>
             <br/>
             <div class="WordSection2">
               <br/>
               <div>
                 <h1 class="ForewordTitle">Foreword&#160;</h1>
                 <div id="_be9158af-7e93-4ee2-90c5-26d31c181934" class="formula">&#160; <span class="stem">(#(r = 1 %)#)</span>&#160; (1)</div>
                 <p>where</p>
                 <table class="dl">
                   <tr>
                     <td valign="top" align="left">
           <span class="stem">(#(r)#)</span>
         </td>
                     <td valign="top">&#8212;</td>
                     <td valign="top">
           <p id="_1b99995d-ff03-40f5-8f2e-ab9665a69b77">is the repeatability limit.</p>
         </td>
                   </tr>
                 </table>
               </div>
               <p>&#160;</p>
             </div>
             <br/>
             <div class="WordSection3">
               <p class="zzSTDTitle1">XXXX</p>
               <hr width="25%"/>
             </div>
           </body>
         </head>
       </html>
    OUTPUT
  end

    it "processes term notes" do
    expect(Asciidoctor::Gb::GbConvert.new({}).convert_file(<<~"INPUT", "test", true)).to be_equivalent_to <<~"OUTPUT"
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
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
           <html xmlns:epub="http://www.idpf.org/2007/ops">
         <head>
           <title>test</title>
           <body lang="EN-US" link="blue" vlink="#954F72">
             <div class="WordSection1">
               <p>&#160;</p>
             </div>
             <br/>
             <div class="WordSection2">
               <p>&#160;</p>
             </div>
             <br/>
             <div class="WordSection3">
               <p class="zzSTDTitle1">XXXX</p>
               <div id="_terms_and_definitions"><h1>1.&#12288;Terms and Definitions</h1><p>For the purposes of this document,
           the following terms and definitions apply.</p>
       <p class="TermNum" id="paddy">1.1</p><p class="Terms" style="text-align:left;">paddy</p><p class="AltTerms" style="text-align:left;">paddy rice</p>
       <p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p>
       <table id="_671a1994-4783-40d0-bc81-987d06ffb74e" class="Note"><tr><td valign="top" class="example_label" style="padding:2pt 2pt 2pt 2pt">Note 1 to entry:</td><td valign="top" class="Note">
         <p class="Note" id="_19830f33-e46c-42cc-94ca-a5ef101132d5">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
       </td></tr></table>
       <table id="_671a1994-4783-40d0-bc81-987d06ffb74f" class="Note"><tr><td valign="top" class="example_label" style="padding:2pt 2pt 2pt 2pt">Note 2 to entry:</td><td valign="top" class="Note">
       <ul><li>A</li></ul>
         <p class="Note" id="_19830f33-e46c-42cc-94ca-a5ef101132d5">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
       </td></tr></table>
       </div>
               <hr width="25%"/>
             </div>
           </body>
         </head>
       </html>
OUTPUT
    end
end
