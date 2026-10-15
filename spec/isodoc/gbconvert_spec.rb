require "spec_helper"
require "fileutils"

RSpec.describe IsoDoc::Gb::HtmlConvert do
  it "processes IsoXML bibliographies" do
    input = <<~"INPUT"

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
    pres_output = IsoDoc::Gb::PresentationXMLConvert.new({})
      .convert("test", input, true)
    expect(strip_guid(IsoDoc::Gb::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(/^.*<body/m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to strip_guid(<<~"OUTPUT")
      <body lang="en"><div class="title-section"><p> </p></div><br/><div class="prefatory-section"><p> </p></div><br/><div class="main-section"><br/><div id="_431ef2eb-8396-9bc6-d97f-294b258fa00e" class="TOC"><h1 class="IntroTitle">Contents</h1></div><br/><div id="_54c89430-7522-0f9f-9f62-8fdcefbecfff"><h1 class="ForewordTitle">Foreword</h1><p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">
        <span class="Hant"><i>Hello</i></span>
        <i>Hello</i>
        </p></div></div></body>
    OUTPUT
  end

    it "does not supply terms boilerplate if prefatory content is already there" do
    FileUtils.rm_f "test.html"
    input = <<~"INPUT"
                  <gb-standard xmlns="http://riboseinc.com/gbstandard">
                  <bibdata>
                    <language>zh</language>
        <script>Hans</script>
      </bibdata>
                      <sections>
          <terms id="_terms_and_definitions" obligation="normative"><title>1.<tab/>Terms and definitions</title>
          <p>Prefatory content</p>
          <term id="paddy">
          <name>1.1.</name>
      <preferred>paddy</preferred><admitted>paddy rice</admitted>
      <admitted>rough rice</admitted>
      <deprecates>cargo rice</deprecates>
      <definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></definition>
      </term>
          </terms></sections>

              </gb-standard>
    INPUT
    pres_output = IsoDoc::Gb::PresentationXMLConvert.new({})
      .convert("test", input, true)
    IsoDoc::Gb::HtmlConvert.new({htmlstylesheet: "lib/isodoc/gb/html/htmlstyle.scss"}).convert("test", pres_output, false)
    html = File.read("test.html", encoding: "utf-8")
      .sub(/^.*<main class="main-section">/m, '<main class="main-section">')
      .sub(%r{</main>.*$}m, "</main>")
    expect(strip_guid(html.gsub(/"#[a-f0-9-]+"/, "#_"))).to be_equivalent_to strip_guid(<<~"OUTPUT")
      <main class="main-section"><button onclick="topFunction()" id="myBtn" title="Go to top">Top</button><br /><div id="_terms_and_definitions"><h1 id="_6282a90c-d339-4b0f-bf49-fbf1f6e32bed"><a class="anchor" href="#_terms_and_definitions"></a><a class="header" href="#_terms_and_definitions">1　1.　Terms and definitions</a></h1>
      <p>Prefatory content</p>
      <div id="paddy"><h2 class="TermNum" id="_80ff9f96-900c-47ae-a652-67380cd765e8"><a class="anchor" href="#paddy"></a><a class="header" href="#paddy">1.11.1.</a></h2></div>




      <p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p>

      </div></main>
    OUTPUT
  end

  it "processes deprecated term" do
    input = <<~"INPUT"
                  <gb-standard xmlns="http://riboseinc.com/gbstandard">
                  <bibdata>
                    <language>zh</language>
        <script>Hans</script>
      </bibdata>
                      <sections>
          <terms id="_terms_and_definitions" obligation="normative"><title>1.<tab/>Terms and definitions</title>
          <term id="paddy">
          <name>1.1.</name>
      <preferred>paddy</preferred><admitted>paddy rice</admitted>
      <admitted>rough rice</admitted>
      <deprecates>cargo rice</deprecates>
      <definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></definition>
      </term>
          </terms></sections>

              </gb-standard>
    INPUT
    pres_output = IsoDoc::Gb::PresentationXMLConvert.new({})
      .convert("test", input, true)
    expect(strip_guid(IsoDoc::Gb::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(/^.*<body/m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to strip_guid(<<~"OUTPUT")
      <body lang="zh"><div class="title-section"><p> </p></div><br/><div class="prefatory-section"><p> </p></div><br/><div class="main-section"><br/><div id="_b681feb2-7e1f-2705-1100-e151c7b5d8b4" class="TOC"><h1 class="IntroTitle">目　次</h1></div><div id="_terms_and_definitions"><h1>1　1.　Terms and definitions</h1>
      <p class="TermNum" id="paddy">1.11.1.</p>




      <p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p>

      </div></div></body>
    OUTPUT
  end

    it "processes modified term source" do
    FileUtils.rm_f "test.html"
    input = <<~"INPUT"
                  <gb-standard xmlns="http://riboseinc.com/gbstandard">
                  <bibdata>
                    <language>zh</language>
        <script>Hans</script>
      </bibdata>
                      <sections>
          <terms id="_terms_and_definitions" obligation="normative"><title>1.<tab/>Terms and definitions</title>
          <term id="paddy">
          <name>1.1.</name>
      <preferred>paddy</preferred><admitted>paddy rice</admitted>
      <admitted>rough rice</admitted>
      <definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></definition>
      <termsource status="modified">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301: 2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality>ISO 7301: 2011&#x3001;&#x7B2C;3.1&#x6761;</origin>
          <modification>
          <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
        </modification>
      </termsource>
      <termsource status="modified">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301: 2011"><locality type="clause"><referenceFrom>3.3</referenceFrom></locality>ISO 7301: 2011&#x3001;&#x7B2C;3.3&#x6761;</origin>
          <modification>
          <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489">Note 2 to entry is not included here</p>
        </modification>
      </termsource>
      </term>
          </terms></sections>

              </gb-standard>
    INPUT
    pres_output = IsoDoc::Gb::PresentationXMLConvert.new({})
      .convert("test", input, true)
    IsoDoc::Gb::HtmlConvert.new({htmlstylesheet: "lib/isodoc/gb/html/htmlstyle.scss"}).convert("test", pres_output, false)
    html = File.read("test.html", encoding: "utf-8")
      .sub(/^.*<main class="main-section">/m, '<main class="main-section">')
      .sub(%r{</main>.*$}m, "</main>")
    expect(strip_guid(html.gsub(/"#[a-f0-9-]+"/, "#_"))).to be_equivalent_to strip_guid(<<~"OUTPUT")
      <main class="main-section"><button onclick="topFunction()" id="myBtn" title="Go to top">Top</button><br /><div id="_terms_and_definitions"><h1 id="_70163ad0-097e-4c09-8b38-6dd5ce82e1d9"><a class="anchor" href="#_terms_and_definitions"></a><a class="header" href="#_terms_and_definitions">1　1.　Terms and definitions</a></h1>
      <div id="paddy"><h2 class="TermNum" id="_5bd7da56-e9f5-45ec-8164-eab92ddb1af2"><a class="anchor" href="#paddy"></a><a class="header" href="#paddy">1.11.1.</a></h2></div>



      <p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p>



      </div></main>
    OUTPUT
  end

    it "processes empty modification of term source" do
    FileUtils.rm_f "test.html"
    input = <<~"INPUT"
                  <gb-standard xmlns="http://riboseinc.com/gbstandard">
                  <bibdata>
                    <language>zh</language>
        <script>Hans</script>
      </bibdata>
                      <sections>
          <terms id="_terms_and_definitions" obligation="normative"><title>1.<tab/>Terms and definitions</title>
          <term id="paddy">
          <name>1.1.</name>
      <preferred>paddy</preferred><admitted>paddy rice</admitted>
      <admitted>rough rice</admitted>
      <definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></definition>
      <termsource status="modified">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301: 2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality>ISO 7301: 2011&#x3001;&#x7B2C;3.1&#x6761;</origin>
          <modification>
          <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489"/>
        </modification>
      </termsource>
      </term>
          </terms></sections>

              </gb-standard>
    INPUT
    pres_output = IsoDoc::Gb::PresentationXMLConvert.new({})
      .convert("test", input, true)
    IsoDoc::Gb::HtmlConvert.new({htmlstylesheet: "lib/isodoc/gb/html/htmlstyle.scss"}).convert("test", pres_output, false)
    html = File.read("test.html", encoding: "utf-8")
      .sub(/^.*<main class="main-section">/m, '<main class="main-section">')
      .sub(%r{</main>.*$}m, "</main>")
    expect(strip_guid(html.gsub(/"#[a-f0-9-]+"/, "#_"))).to be_equivalent_to strip_guid(<<~"OUTPUT")
      <main class="main-section"><button onclick="topFunction()" id="myBtn" title="Go to top">Top</button><br /><div id="_terms_and_definitions"><h1 id="_d1bc3c9e-881d-424d-b7dc-df1a97d2db1d"><a class="anchor" href="#_terms_and_definitions"></a><a class="header" href="#_terms_and_definitions">1　1.　Terms and definitions</a></h1>
      <div id="paddy"><h2 class="TermNum" id="_18802305-d682-4648-b549-9c7f7c01efcb"><a class="anchor" href="#paddy"></a><a class="header" href="#paddy">1.11.1.</a></h2></div>



      <p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p>


      </div></main>
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
    expect(htmlencode(html.gsub(/"#[a-f0-9-]+"/, "#_"))).to match(%r{<div class="coverpage_footer">\s*<img class="logo" src="[^"]+_htmlimages/[^"]+\.gif" alt="[^"]*" width="680" height="90" />\s*</div>})
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
    expect(htmlencode(html.gsub(/"#[a-f0-9-]+"/, "#_"))).to match(%r{<div class="coverpage_footer">\s*<img class="logo" src="[^"]+_htmlimages/[^"]+\.gif" alt="[^"]*" width="680" height="90" />\s*</div>})
  end

end
