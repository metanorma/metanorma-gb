require "spec_helper"
require "fileutils"

RSpec.describe IsoDoc::Gb::HtmlConvert do
  it "cleans up formulas" do
    input = <<~"INPUT"
          <html>
          <body>
            <table class="dl">
              <p>Text</p>
            </div>
          </body>
          </html>
    INPUT
    pres_output = IsoDoc::Gb::PresentationXMLConvert.new({})
      .convert("test", input, true)
    expect(strip_guid(IsoDoc::Gb::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(/^.*<body/m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to strip_guid(<<~"OUTPUT")
<body lang="zh"><div class="title-section"><p> </p></div><br/><div class="prefatory-section"><p> </p></div><br/><div class="main-section"></div></body>
    OUTPUT
  end

  it "cleans up examples" do
    input = <<~"INPUT"
          <html>
          <body>
            <table class="Note">
              <p>Text</p>
            </div>
          </body>
          </html>
    INPUT
    pres_output = IsoDoc::Gb::PresentationXMLConvert.new({})
      .convert("test", input, true)
    expect(strip_guid(IsoDoc::Gb::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(/^.*<body/m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to strip_guid(<<~"OUTPUT")
<body lang="zh"><div class="title-section"><p> </p></div><br/><div class="prefatory-section"><p> </p></div><br/><div class="main-section"></div></body>
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
    IsoDoc::Gb::WordConvert.new({wordstylesheet: "lib/isodoc/gb/html/wordstyle.scss", wordintropage: "lib/isodoc/gb/html/word_gb_intro.html"}).convert("test", <<~"INPUT", false)
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
                                   <bibdata> <language>en</language> <script>Latn</script> </bibdata>
        <sections>
               <clause id="A" inline-header="false" obligation="normative"><title>1.<tab/>Clause 4</title>
<clause id="N" inline-header="false" obligation="normative">

         <title>1.1.<tab/>Introduction<bookmark id="Q"/> to this<fn reference="1">
  <p id="_ff27c067-2785-4551-96cf-0a73530ff1e6">Formerly denoted as 15 % (m/m).</p>
</fn></title>
       </clause>
       <clause id="O" inline-header="false" obligation="normative">
         <title>1.2.<tab/>Clause 4.2</title>
         <p>A<fn reference="1">
  <p id="_ff27c067-2785-4551-96cf-0a73530ff1e6">Formerly denoted as 15 % (m/m).</p>
</fn></p>
       </clause></clause>
        </sections>
        </gb-standard>
    INPUT
    word = File.read("test.doc", encoding: "utf-8").sub(/^.*<div class="WordSection2">/m, '<div class="WordSection2">').
      sub(%r{<p class="MsoNormal">\s*<br clear="all" class="section"/>\s*</p>\s*<div class="WordSection3">.*$}m, "")
    expect(word.gsub(/_Toc\d\d+/, "_Toc")).to be_equivalent_to <<~'OUTPUT'
<div class="WordSection2"><p class="MsoNormal"></p>zzContents style='margin-top:0cm'&gt;Contents<p class="MsoNormal">&#xA0;</p></div>
    
OUTPUT
    end

end
