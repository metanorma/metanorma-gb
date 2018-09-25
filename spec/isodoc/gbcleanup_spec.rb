require "spec_helper"
require "fileutils"

RSpec.describe IsoDoc::Gb::HtmlConvert do
  it "cleans up formulas" do
    expect(IsoDoc::Gb::HtmlConvert.new({}).cleanup(Nokogiri::XML(<<~"INPUT")).to_s).to be_equivalent_to <<~"OUTPUT"
    <html>
    <body>
      <table class="dl">
        <p>Text</p>
      </div>
    </body>
    </html>
    INPUT
           <?xml version="1.0"?>
       <html>
       <body>
         <table class="dl">
           <p class="dl">Text</p>
         </table>
       </body>
       </html>
    OUTPUT
  end

  it "cleans up examples" do
    expect(IsoDoc::Gb::HtmlConvert.new({}).cleanup(Nokogiri::XML(<<~"INPUT")).to_s).to be_equivalent_to <<~"OUTPUT"
    <html>
    <body>
      <table class="Note">
        <p>Text</p>
      </div>
    </body>
    </html>
    INPUT
           <?xml version="1.0"?>
       <html>
       <body>
         <table class="Note">
           <p class="Note">Text</p>
         </table>
       </body>
       </html>
    OUTPUT
  end

  it "cleans up titles" do
    gbc = IsoDoc::Gb::HtmlConvert.new({})
    docxml, filename, dir = gbc.convert_init(<<~"INPUT", "test", true)
    <gb-standard xmlns="http://riboseinc.com/gbstandard">
<bibdata>
<script>Hans</script>
</bibdata>
</gb-standard>
    INPUT
    expect(gbc.cleanup(Nokogiri::XML(<<~"INPUT")).to_s).to be_equivalent_to <<~"OUTPUT"
    <html>
    <body>
        <p class="zzContents">Text</p>
        <p class="ForewordTitle">Text</p>
        <p class="IntroTitle">Text</p>
        <h1 class="Annex">Text<br/>Text2</h1>
    </body>
    </html>
    INPUT
           <?xml version="1.0"?>
       <html>
       <body>
                  <p class="zzContents">T&#xA0;&#xA0;e&#xA0;&#xA0;x&#xA0;&#xA0;t</p>
           <p class="ForewordTitle">T&#xA0;&#xA0;e&#xA0;&#xA0;x&#xA0;&#xA0;t</p>
           <p class="IntroTitle">T&#xA0;&#xA0;e&#xA0;&#xA0;x&#xA0;&#xA0;t</p>
           <h1 class="Annex">T&#xA0;&#xA0;e&#xA0;&#xA0;x&#xA0;&#xA0;t<br/>Text2</h1>
       </body>
       </html>
    OUTPUT
  end

  it "cleans up terms" do
    gbc = IsoDoc::Gb::HtmlConvert.new({})
    docxml, filename, dir = gbc.convert_init(<<~"INPUT", "test", true)
    <gb-standard xmlns="http://riboseinc.com/gbstandard">
<bibdata>
<language>en</language>
<script>Latn</script>
</bibdata>
</gb-standard>
    INPUT
    expect(gbc.cleanup(Nokogiri::XML(<<~"INPUT")).to_s).to be_equivalent_to <<~"OUTPUT"
    <html>
    <body>
        <p class="Terms" lang="zh">Text</p>
        <p class="Terms" lang="en">Text2</p>
        <p class="AltTerms" lang="zh">Text</p>
        <p class="AltTerms" lang="en">Text2</p>
        <p class="DeprecatedTerms" lang="zh">DEPRECATED: Text</p>
        <p class="DeprecatedTerms" lang="en">DEPRECATED: Text2</p>
    </body>
    </html>
    INPUT
           <?xml version="1.0"?>
       <html>
       <body>
           <p class="Terms" lang="zh">Text&#x3000;Text2</p>
           <p class="AltTerms" lang="zh">Text&#x3000;Text2</p>
           <p class="DeprecatedTerms" lang="zh">DEPRECATED: Text&#x3000;Text2</p>
       </body>
       </html>
    OUTPUT
  end

    it "populates Word ToC" do
    FileUtils.rm_f "test.doc"
    IsoDoc::Gb::WordConvert.new({wordstylesheet: "lib/asciidoctor/gb/html/wordstyle.scss", wordintropage: "lib/asciidoctor/gb/html/word_gb_intro.html"}).convert("test", <<~"INPUT", false)
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
                                   <bibdata> <language>en</language> <script>Latn</script> </bibdata>
        <sections>
               <clause inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">

         <title>Introduction<bookmark id="Q"/> to this<fn reference="1">
  <p id="_ff27c067-2785-4551-96cf-0a73530ff1e6">Formerly denoted as 15 % (m/m).</p>
</fn></title>
       </clause>
       <clause id="O" inline-header="false" obligation="normative">
         <title>Clause 4.2</title>
         <p>A<fn reference="1">
  <p id="_ff27c067-2785-4551-96cf-0a73530ff1e6">Formerly denoted as 15 % (m/m).</p>
</fn></p>
       </clause></clause>
        </sections>
        </gb-standard>
    INPUT
    word = File.read("test.doc", encoding: "utf-8").sub(/^.*<div class="WordSection2">/m, '<div class="WordSection2">').
      sub(%r{<br clear="all" class="section"/>\s*<div class="WordSection3">.*$}m, "")
    expect(word.gsub(/_Toc\d\d+/, "_Toc")).to be_equivalent_to <<~'OUTPUT'
    <div class="WordSection2"><p class="zzContents" style="margin-top:0cm">Table of contents</p>
       
       <p class="MsoToc1"><span lang="EN-GB" xml:lang="EN-GB"><span style="mso-element:field-begin"></span><span style="mso-spacerun:yes">&#xA0;</span>TOC
         \o "1-2" \h \z \u <span style="mso-element:field-separator"></span></span>
       <span class="MsoHyperlink"><span lang="EN-GB" style="mso-no-proof:yes" xml:lang="EN-GB">
       <a href="#_Toc">1.&#x3000;Clause 4<span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
       <span style="mso-tab-count:1 dotted">. </span>
       </span><span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
       <span style="mso-element:field-begin"></span></span>
       <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"> PAGEREF _Toc \h </span>
         <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"><span style="mso-element:field-separator"></span></span><span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">1</span>
         <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"></span><span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"><span style="mso-element:field-end"></span></span></a></span></span></p>

       <p class="MsoToc2">
         <span class="MsoHyperlink">
           <span lang="EN-GB" style="mso-no-proof:yes" xml:lang="EN-GB">
       <a href="#_Toc">1.1.&#x3000;Introduction to this<span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
       <span style="mso-tab-count:1 dotted">. </span>
       </span><span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
       <span style="mso-element:field-begin"></span></span>
       <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"> PAGEREF _Toc \h </span>
         <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"><span style="mso-element:field-separator"></span></span><span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">1</span>
         <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"></span><span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"><span style="mso-element:field-end"></span></span></a></span>
         </span>
       </p>

       <p class="MsoToc2">
         <span class="MsoHyperlink">
           <span lang="EN-GB" style="mso-no-proof:yes" xml:lang="EN-GB">
       <a href="#_Toc">1.2.&#x3000;Clause 4.2<span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
       <span style="mso-tab-count:1 dotted">. </span>
       </span><span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
       <span style="mso-element:field-begin"></span></span>
       <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"> PAGEREF _Toc \h </span>
         <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"><span style="mso-element:field-separator"></span></span><span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">1</span>
         <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"></span><span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"><span style="mso-element:field-end"></span></span></a></span>
         </span>
       </p>

       <p class="MsoToc1">
         <span lang="EN-GB" xml:lang="EN-GB">
           <span style="mso-element:field-end"></span>
         </span>
         <span lang="EN-GB" xml:lang="EN-GB">
           <p class="MsoNormal">&#xA0;</p>
         </span>
       </p>


               <p class="MsoNormal">&#xA0;</p>
             </div>
OUTPUT
    end

end
