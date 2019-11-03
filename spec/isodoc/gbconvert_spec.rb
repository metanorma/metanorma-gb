require "spec_helper"
require "fileutils"

RSpec.describe IsoDoc::Gb::HtmlConvert do
  it "processes IsoXML bibliographies" do
              expect(xmlpp(IsoDoc::Gb::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(/^.*<body/m, "<body xmlns:epub='epub'").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")

            <gb-standard xmlns="http://riboseinc.com/gbstandard">
                           <bibdata> <language>en</language> <script>Latn</script> </bibdata>
    <preface><foreword>
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">
  <eref bibitemid="ISO712"/>
  <eref bibitemid="ref1"/>
  <eref bibitemid="ref10"/>
  </p>
    </foreword></preface>
    <bibliography><references id="_normative_references" obligation="informative"><title>Normative References</title>
               <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
<bibitem id="ISO712" type="standard">
  <title format="text/plain">Cereals and cereal products</title>
  <docidentifier type="ISO">ISO 712</docidentifier>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>International Organization for Standardization</name>
    </organization>
  </contributor>
</bibitem>
<bibitem id="ISO16634" type="standard">
  <title format="text/plain">Cereals, pulses, milled cereal products, oilseeds and animal feeding stuffs</title>
  <docidentifier type="Chinese Standard">GM/T 16634:-- (all parts)</docidentifier>
  <date type="published"><on>--</on></date>
  <contributor>
    <role type="publisher"/>
    <organization>
      <abbreviation>ISO</abbreviation>
    </organization>
  </contributor>
  <note format="text/plain" reference="1">ISO DATE: Under preparation. (Stage at the time of publication ISO/DIS 16634)</note>
  <extent type="part"><referenceFrom>all</referenceFrom></extent>
</bibitem>
<bibitem id="ISO20483" type="standard">
  <title format="text/plain">Cereals and pulses</title>
  <docidentifier type="ISO">ISO 20483:2013-2014</docidentifier>
  <date type="published"><from>2013</from><to>2014</to></date>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>International Organization for Standardization</name>
    </organization>
  </contributor>
</bibitem>
<bibitem id="ref1">
  <formattedref format="application/x-isodoc+xml"><smallcap>Standard No I.C.C 167</smallcap>. <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em> (see <link target="http://www.icc.or.at"/>)</formattedref>
  <docidentifier>ICC 167</docidentifier>
</bibitem>

</references><references id="_bibliography" obligation="informative">
  <title>Bibliography</title>
<bibitem id="ISO3696" type="standard">
  <title format="text/plain">Water for analytical laboratory use</title>
  <docidentifier type="ISO">ISO 3696</docidentifier>
  <contributor>
    <role type="publisher"/>
    <organization>
      <abbreviation>ISO</abbreviation>
    </organization>
  </contributor>
</bibitem>
<bibitem id="ref10">
  <formattedref format="application/x-isodoc+xml"><smallcap>Standard No I.C.C 167</smallcap>. <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em> (see <link target="http://www.icc.or.at"/>)</formattedref>
  <docidentifier type="metanorma">[10]</docidentifier>
</bibitem>
<bibitem id="ref11">
  <formattedref format="application/x-isodoc+xml"><smallcap>Standard No I.C.C 167</smallcap>. <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em> (see <link target="http://www.icc.or.at"/>)</formattedref>
  <docidentifier type="IETF">RFC 10</docidentifier>
</bibitem>


</references>
</bibliography>
    </gb-standard>
    INPUT
              #{HTML_HDR.sub(/<body/, "<body xmlns:epub='epub'")}
             <br/>
             <div>
               <h1 class="ForewordTitle">Foreword&#160;</h1>
               <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">
         <a href="#ISO712">ISO 712</a>
         <a href="#ref1">ICC 167</a>
         <a href="#ref10">[10]</a>
         </p>
             </div>
             <p class="zzSTDTitle1">XXXX</p>
             <div>
               <h1>1.&#12288;Normative references</h1>
               <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
               <p id="ISO712" class="NormRef">ISO 712, <i>Cereals and cereal products</i></p>
               <p id="ISO16634" class="NormRef">GM/T 16634:-- (all parts)<a rel="footnote" href="#fn:1" epub:type="footnote"><sup>1</sup></a>, <i>Cereals, pulses, milled cereal products, oilseeds and animal feeding stuffs</i></p>
               <p id="ISO20483" class="NormRef">ISO 20483:2013-2014, <i>Cereals and pulses</i></p>
               <p id="ref1" class="NormRef">ICC 167, <span style="font-variant:small-caps;">Standard No I.C.C 167</span>. <i>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</i> (see <a href="http://www.icc.or.at">http://www.icc.or.at</a>)</p>
             </div>
             <br/>
             <div>
               <h1 class="Section3">Bibliography</h1>
               <p id="ISO3696" class="Biblio">[1]&#160; ISO 3696, <i>Water for analytical laboratory use</i></p>
               <p id="ref10" class="Biblio">[10]&#160; <span style="font-variant:small-caps;">Standard No I.C.C 167</span>. <i>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</i> (see <a href="http://www.icc.or.at">http://www.icc.or.at</a>)</p>
               <p id="ref11" class="Biblio">[3]&#160; IETF RFC 10,<span style="font-variant:small-caps;">Standard No I.C.C 167</span>. <i>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</i> (see <a href="http://www.icc.or.at">http://www.icc.or.at</a>)</p>
             </div>
             <hr width="25%"/>
             <aside id="fn:1" class="footnote">
         <p>Under preparation. (Stage at the time of publication ISO/DIS 16634)</p>
       </aside>
           </div>
         </body>
    OUTPUT
  end

  it "processes string tag" do
              expect(xmlpp(IsoDoc::Gb::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(/^.*<body/m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")

            <gb-standard xmlns="http://riboseinc.com/gbstandard">
                           <bibdata> <language>en</language> <script>Latn</script> </bibdata>
    <preface><foreword>
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">
  <string script="Hant"><em>Hello</em></string>
  <string script="Hans"><em>Hello</em></string>
  </p>
    </foreword></preface>
    </gb-standard>
    INPUT
        #{HTML_HDR}
             <br/>
             <div>
               <h1 class="ForewordTitle">Foreword&#160;</h1>
               <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">
       <span class="Hant"><i>Hello</i></span>
       <i>Hello</i>
       </p>
             </div>
             <p class="zzSTDTitle1">XXXX</p>
             <hr width="25%"/>
           </div>
         </body>
    OUTPUT
  end

    it "does not supply terms boilerplate if prefatory content is already there" do
    FileUtils.rm_f "test.html"
    IsoDoc::Gb::HtmlConvert.new({htmlstylesheet: "lib/isodoc/gb/html/htmlstyle.scss"}).convert("test", <<~"INPUT", false)
            <gb-standard xmlns="http://riboseinc.com/gbstandard">
            <bibdata>
              <language>zh</language>
  <script>Hans</script>
</bibdata>
                <sections>
    <terms id="_terms_and_definitions" obligation="normative"><title>Terms and Definitions</title>
    <p>Prefatory content</p>
    <term id="paddy"><preferred>paddy</preferred><admitted>paddy rice</admitted>
<admitted>rough rice</admitted>
<deprecates>cargo rice</deprecates>
<definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></definition>
</term>
    </terms></sections>

        </gb-standard>
    INPUT
    html = File.read("test.html", encoding: "utf-8").sub(/^.*<main class="main-section">/m, '<main class="main-section">').
      sub(%r{</main>.*$}m, "</main>")
    expect(xmlpp(html.gsub(/"#[a-f0-9-]+"/, "#_"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
           <main class="main-section"><button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>
               <p class="zzSTDTitle1">XXXX</p>
               <div id="_terms_and_definitions"><h1>1.&#x3000;&#x672F;&#x8BED;&#x548C;&#x5B9A;&#x4E49;</h1>
               <p>Prefatory content</p>
       <h2 class="TermNum" id="paddy">1.1.</h2><p class="Terms" style="text-align:left;">paddy</p><p class="AltTerms" style="text-align:left;">paddy rice&#x3000;rough rice</p>

       <p class="DeprecatedTerms">&#x88AB;&#x53D6;&#x4EE3;&#xFF1A;cargo rice</p>
       <p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p>
       </div>
               <hr width="25%" />
             </main>
    OUTPUT
  end

  it "processes deprecated term" do
    FileUtils.rm_f "test.html"
    IsoDoc::Gb::HtmlConvert.new({htmlstylesheet: "lib/isodoc/gb/html/htmlstyle.scss"}).convert("test", <<~"INPUT", false)
            <gb-standard xmlns="http://riboseinc.com/gbstandard">
            <bibdata>
              <language>zh</language>
  <script>Hans</script>
</bibdata>
                <sections>
    <terms id="_terms_and_definitions" obligation="normative"><title>Terms and Definitions</title>
    <term id="paddy"><preferred>paddy</preferred><admitted>paddy rice</admitted>
<admitted>rough rice</admitted>
<deprecates>cargo rice</deprecates>
<definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></definition>
</term>
    </terms></sections>

        </gb-standard>
    INPUT
    html = File.read("test.html", encoding: "utf-8").sub(/^.*<main class="main-section">/m, '<main class="main-section">').
      sub(%r{</main>.*$}m, "</main>")
    expect(xmlpp(html.gsub(/"#[a-f0-9-]+"/, "#_"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
           <main class="main-section"><button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>
               <p class="zzSTDTitle1">XXXX</p>
               <div id="_terms_and_definitions"><h1>1.&#x3000;&#x672F;&#x8BED;&#x548C;&#x5B9A;&#x4E49;</h1>
       <h2 class="TermNum" id="paddy">1.1.</h2><p class="Terms" style="text-align:left;">paddy</p><p class="AltTerms" style="text-align:left;">paddy rice&#x3000;rough rice</p>

       <p class="DeprecatedTerms">&#x88AB;&#x53D6;&#x4EE3;&#xFF1A;cargo rice</p>
       <p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p>
       </div>
               <hr width="25%" />
             </main>
    OUTPUT
  end

    it "processes modified term source" do
    FileUtils.rm_f "test.html"
    IsoDoc::Gb::HtmlConvert.new({htmlstylesheet: "lib/isodoc/gb/html/htmlstyle.scss"}).convert("test", <<~"INPUT", false)
            <gb-standard xmlns="http://riboseinc.com/gbstandard">
            <bibdata>
              <language>zh</language>
  <script>Hans</script>
</bibdata>
                <sections>
    <terms id="_terms_and_definitions" obligation="normative"><title>Terms and Definitions</title>
    <term id="paddy"><preferred>paddy</preferred><admitted>paddy rice</admitted>
<admitted>rough rice</admitted>
<definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></definition>
<termsource status="modified">
  <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301: 2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
    <modification>
    <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
  </modification>
</termsource>
</term>
    </terms></sections>

        </gb-standard>
    INPUT
    html = File.read("test.html", encoding: "utf-8").sub(/^.*<main class="main-section">/m, '<main class="main-section">').
      sub(%r{</main>.*$}m, "</main>")
    expect(xmlpp(htmlencode(html.gsub(/"#[a-f0-9-]+"/, "#_")))).to be_equivalent_to xmlpp(<<~"OUTPUT")
           <main class="main-section"><button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>
               <p class="zzSTDTitle1">XXXX</p>
               <div id="_terms_and_definitions"><h1>1.&#x3000;&#x672F;&#x8BED;&#x548C;&#x5B9A;&#x4E49;</h1>
       <h2 class="TermNum" id="paddy">1.1.</h2><p class="Terms" style="text-align:left;">paddy</p><p class="AltTerms" style="text-align:left;">paddy rice&#x3000;rough rice</p>

       <p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p>
       <p>&#x3010;<a href="#ISO7301">ISO 7301: 2011&#x3001;&#x7B2C;3.1&#x6761;</a>&#x3001;&#x6539;&#x5199;&#x2014;The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here&#x3011;</p>
       </div>
               <hr width="25%" />
             </main>
    OUTPUT
  end

        it "processes empty modification of term source" do
    FileUtils.rm_f "test.html"
    IsoDoc::Gb::HtmlConvert.new({htmlstylesheet: "lib/isodoc/gb/html/htmlstyle.scss"}).convert("test", <<~"INPUT", false)
            <gb-standard xmlns="http://riboseinc.com/gbstandard">
            <bibdata>
              <language>zh</language>
  <script>Hans</script>
</bibdata>
                <sections>
    <terms id="_terms_and_definitions" obligation="normative"><title>Terms and Definitions</title>
    <term id="paddy"><preferred>paddy</preferred><admitted>paddy rice</admitted>
<admitted>rough rice</admitted>
<definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></definition>
<termsource status="modified">
  <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301: 2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
    <modification>
    <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489"/>
  </modification>
</termsource>
</term>
    </terms></sections>

        </gb-standard>
    INPUT
    html = File.read("test.html", encoding: "utf-8").sub(/^.*<main class="main-section">/m, '<main class="main-section">').
      sub(%r{</main>.*$}m, "</main>")
    expect(xmlpp(htmlencode(html.gsub(/"#[a-f0-9-]+"/, "#_")))).to be_equivalent_to xmlpp(<<~"OUTPUT")
           <main class="main-section"><button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>
               <p class="zzSTDTitle1">XXXX</p>
               <div id="_terms_and_definitions"><h1>1.&#x3000;&#x672F;&#x8BED;&#x548C;&#x5B9A;&#x4E49;</h1>
       <h2 class="TermNum" id="paddy">1.1.</h2><p class="Terms" style="text-align:left;">paddy</p><p class="AltTerms" style="text-align:left;">paddy rice&#x3000;rough rice</p>

       <p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p>
       <p>&#x3010;<a href="#ISO7301">ISO 7301: 2011&#x3001;&#x7B2C;3.1&#x6761;</a>&#x3001;&#x6539;&#x5199;&#x3011;</p>
       </div>
               <hr width="25%" />
             </main>
    OUTPUT
  end

  it "processes logo for social" do
    FileUtils.rm_f "test.doc"
    FileUtils.rm_f "test.html"
    IsoDoc::Gb::HtmlConvert.new({htmlstylesheet: "lib/isodoc/gb/html/htmlstyle.scss", htmlcoverpage: "lib/isodoc/gb/html/html_gb_titlepage.html"}).
      convert("test", <<~"INPUT", false)
      <gb-standard xmlns="http://riboseinc.com/gbstandard">
      <bibdata>
      <language>zh</language>
      <script>Hans</script>
      <ext>
        <gbtype>
    <gbscope>social-group</gbscope>
  </gbtype>
  </ext>
      </bibdata>
      <sections>
      </sections>
      </gb-standard>
    INPUT
    html = File.read("test.html", encoding: "utf-8").sub(/^.*<div class="title-section">/m, '<div class="title-section">').
      sub(%r{<div class="prefatory-section".*$}m, "")
    expect(html.gsub(/"#[a-f0-9-]+"/, "#_")).to match(%r{<div class="coverpage-logo-gb-img"></div>})
  end

  it "processes logo for local" do
    FileUtils.rm_f "test.doc"
    FileUtils.rm_f "test.html"
    IsoDoc::Gb::HtmlConvert.new({htmlstylesheet: "lib/isodoc/gb/html/htmlstyle.scss", htmlcoverpage: "lib/isodoc/gb/html/html_gb_titlepage.html"}).
      convert("test", <<~"INPUT", false)
      <gb-standard xmlns="http://riboseinc.com/gbstandard">
      <bibdata>
      <language>zh</language>
      <script>Hans</script>
      <ext>
        <gbtype>
    <gbscope>local</gbscope>
        <gbprefix>81</gbprefix>
  </gbtype>
  </ext>
      </bibdata>
      <sections>
      </sections>
      </gb-standard>
    INPUT
    html = File.read("test.html", encoding: "utf-8").sub(/^.*<div class="title-section">/m, '<div class="title-section">').
      sub(%r{<div class="prefatory-section".*$}m, "")
    expect(html.gsub(/"#[a-f0-9-]+"/, "#_")).to match(%r{<div class="coverpage-logo-gb-img"><img class="logo" width="113" height="56" src="[^"]+" alt="DB" /><span style="font-weight:bold">81</span></div>})
  end

  it "processes logo for sector, no available logo" do
    FileUtils.rm_f "test.doc"
    FileUtils.rm_f "test.html"
    IsoDoc::Gb::HtmlConvert.new({htmlstylesheet: "lib/isodoc/gb/html/htmlstyle.scss", htmlcoverpage: "lib/isodoc/gb/html/html_gb_titlepage.html"}).
      convert("test", <<~"INPUT", false)
      <gb-standard xmlns="http://riboseinc.com/gbstandard">
      <bibdata>
      <language>zh</language>
      <script>Hans</script>
      <ext>
        <gbtype>
    <gbscope>sector</gbscope>
        <gbprefix>NY</gbprefix>
  </gbtype>
  </ext>
      </bibdata>
      <sections>
      </sections>
      </gb-standard>
    INPUT
    html = File.read("test.html", encoding: "utf-8").sub(/^.*<div class="title-section">/m, '<div class="title-section">').
      sub(%r{<div class="prefatory-section".*$}m, "")
    expect(html.gsub(/"#[a-f0-9-]+"/, "#_")).to match(%r{<div class="coverpage-logo-gb-img"><span style="font-size:36pt;font-weight:bold">NY</span></div>})
  end

  it "processes logo for sector with available logo" do
    FileUtils.rm_f "test.doc"
    FileUtils.rm_f "test.html"
    IsoDoc::Gb::HtmlConvert.new({htmlstylesheet: "lib/isodoc/gb/html/htmlstyle.scss", htmlcoverpage: "lib/isodoc/gb/html/html_gb_titlepage.html"}).
      convert("test", <<~"INPUT", false)
      <gb-standard xmlns="http://riboseinc.com/gbstandard">
      <bibdata>
      <language>zh</language>
      <script>Hans</script>
      <ext>
        <gbtype>
    <gbscope>sector</gbscope>
        <gbprefix>GM</gbprefix>
  </gbtype>
  </ext>
      </bibdata>
      <sections>
      </sections>
      </gb-standard>
    INPUT
    html = File.read("test.html", encoding: "utf-8").sub(/^.*<div class="title-section">/m, '<div class="title-section">').
      sub(%r{<div class="prefatory-section".*$}m, "")
    expect(html.gsub(/"#[a-f0-9-]+"/, "#_")).to match(%r{<div class="coverpage-logo-gb-img"><img class="logo" width="113" height="56" src="[^"]+" alt="GM" /></div>})
  end

  it "processes agency name" do
    FileUtils.rm_f "test.doc"
    FileUtils.rm_f "test.html"
    IsoDoc::Gb::HtmlConvert.new({htmlstylesheet: "lib/isodoc/gb/html/htmlstyle.scss", htmlcoverpage: "lib/isodoc/gb/html/html_gb_titlepage.html"}).
      convert("test", <<~"INPUT", false)
      <gb-standard xmlns="http://riboseinc.com/gbstandard">
      <bibdata>
      <language>en</language>
      <script>Latn</script>
      <ext>
        <gbtype>
    <gbscope>sector</gbscope>
        <gbprefix>GM</gbprefix>
  </gbtype>
  </ext>
      </bibdata>
      <sections>
      </sections>
      </gb-standard>
    INPUT
    html = File.read("test.html", encoding: "utf-8").sub(/^.*<div class="title-section">/m, '<div class="title-section">').
      sub(%r{<div class="prefatory-section".*$}m, "")
    expect(html.gsub(/"#[a-f0-9-]+"/, "#_")).to match(%r{<div class="coverpage_footer">\s*State Administration Of Cryptography\s*</div>})
  end

  it "processes agency name, GB" do
    FileUtils.rm_f "test.doc"
    FileUtils.rm_f "test.html"
    IsoDoc::Gb::HtmlConvert.new({htmlstylesheet: "lib/isodoc/gb/html/htmlstyle.scss", htmlcoverpage: "lib/isodoc/gb/html/html_gb_titlepage.html"}).
      convert("test", <<~"INPUT", false)
      <gb-standard xmlns="http://riboseinc.com/gbstandard">
      <bibdata>
      <language>zh</language>
      <script>Hans</script>
      <ext>
        <gbtype>
    <gbscope>national</gbscope>
        <gbprefix>GB</gbprefix>
  </gbtype>
  </ext>
      </bibdata>
      <sections>
      </sections>
      </gb-standard>
    INPUT
    html = File.read("test.html", encoding: "utf-8").sub(/^.*<div class="title-section">/m, '<div class="title-section">').
      sub(%r{<div class="prefatory-section".*$}m, "")
    expect(htmlencode(html.gsub(/"#[a-f0-9-]+"/, "#_"))).to match(%r{<div class="coverpage_footer">\s*<img class="logo" src="[^"]+" alt="&#x4E2D;&#x534E;&#x4EBA;&#x6C11;&#x5171;&#x548C;&#x56FD;&#x56FD;&#x5BB6;&#x8D28;&#x91CF;&#x76D1;&#x7763;&#x68C0;&#x9A8C;&#x68C0;&#x75AB;&#x603B;&#x5C40;,&#x4E2D;&#x56FD;&#x56FD;&#x5BB6;&#x6807;&#x51C6;&#x5316;&#x7BA1;&#x7406;&#x59D4;&#x5458;&#x4F1A;" width="680" height="90" />\s*</div>})
  end

    it "processes agency name, GB" do
    FileUtils.rm_f "test.doc"
    FileUtils.rm_f "test.html"
    IsoDoc::Gb::HtmlConvert.new({htmlstylesheet: "lib/isodoc/gb/html/htmlstyle.scss", htmlcoverpage: "lib/isodoc/gb/html/html_gb_titlepage.html"}).
      convert("test", <<~"INPUT", false)
      <gb-standard xmlns="http://riboseinc.com/gbstandard">
      <bibdata>
      <language>zh</language>
      <script>Hans</script>
      <ext>
        <gbtype>
    <gbscope>national</gbscope>
        <gbprefix>GB</gbprefix>
  </gbtype>
  </ext>
      </bibdata>
      <sections>
      </sections>
      </gb-standard>
    INPUT
    html = File.read("test.html", encoding: "utf-8").sub(/^.*<div class="title-section">/m, '<div class="title-section">').
      sub(%r{<div class="prefatory-section".*$}m, "")
    expect(htmlencode(html.gsub(/"#[a-f0-9-]+"/, "#_"))).to match(%r{<div class="coverpage_footer">\s*<img class="logo" src="[^"]+" alt="&#x4E2D;&#x534E;&#x4EBA;&#x6C11;&#x5171;&#x548C;&#x56FD;&#x56FD;&#x5BB6;&#x8D28;&#x91CF;&#x76D1;&#x7763;&#x68C0;&#x9A8C;&#x68C0;&#x75AB;&#x603B;&#x5C40;,&#x4E2D;&#x56FD;&#x56FD;&#x5BB6;&#x6807;&#x51C6;&#x5316;&#x7BA1;&#x7406;&#x59D4;&#x5458;&#x4F1A;" width="680" height="90" />\s*</div>})
  end

end
