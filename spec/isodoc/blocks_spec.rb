require "spec_helper"

RSpec.describe IsoDoc::Gb::HtmlConvert do
  it "processes unlabelled notes" do
    input = <<~"INPUT"

              <gb-standard xmlns="http://riboseinc.com/gbstandard">
                             <bibdata> <language>en</language> <script>Latn</script> </bibdata>
          <preface><foreword>
          <note id="A" keep-with-next="true" keep-lines-together="true">
          <name>NOTE</name>
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
      </note>
          </foreword></preface>
          </gb-standard>
    INPUT
    pres_output = IsoDoc::Gb::PresentationXMLConvert.new({})
      .convert("test", input, true)
    expect(strip_guid(IsoDoc::Gb::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(/^.*<body/m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_xml_equivalent_to(strip_guid(<<~"OUTPUT")).with_profile(:spec_friendly)
      <body lang="en"><div class="title-section"><p> </p></div><br/><div class="prefatory-section"><p> </p></div><br/><div class="main-section"><br/><div id="_431ef2eb-8396-9bc6-d97f-294b258fa00e" class="TOC"><h1 class="IntroTitle">Contents</h1></div><br/><div id="_dc33a740-6584-3234-81be-fdd0c2742799"><h1 class="ForewordTitle">Foreword</h1><table id="A" class="Note" style="page-break-after: avoid;page-break-inside: avoid;"><tr><td class="example_label" style="padding:2pt 2pt 2pt 2pt;vertical-align:top;">NOTE: </td><td style="vertical-align:top;" class="Note">
      NOTENOTE　
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
      </td></tr></table></div></div></body>
    OUTPUT
  end

  it "processes sequences of notes" do
    input = <<~"INPUT"
              <gb-standard xmlns="http://riboseinc.com/gbstandard">
                             <bibdata> <language current="true">en</language> <script current="true">Latn</script> </bibdata>
          <preface><foreword>
          <note id="note1">
          <name>NOTE  1</name>
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
      </note>
          <note id="note2">
          <name>NOTE  2</name>
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
      </note>
          </foreword></preface>
          </gb-standard>
    INPUT
    pres_output = IsoDoc::Gb::PresentationXMLConvert.new({})
      .convert("test", input, true)
    expect(strip_guid(IsoDoc::Gb::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(/^.*<body/m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_xml_equivalent_to(strip_guid(<<~"OUTPUT")).with_profile(:spec_friendly)
      <body lang="en"><div class="title-section"><p> </p></div><br/><div class="prefatory-section"><p> </p></div><br/><div class="main-section"><br/><div id="_431ef2eb-8396-9bc6-d97f-294b258fa00e" class="TOC"><h1 class="IntroTitle">Contents</h1></div><br/><div id="_909633b1-dc37-99e5-6b1d-5b5d7ac3ef6c"><h1 class="ForewordTitle">Foreword</h1><table id="note1" class="Note"><tr><td class="example_label" style="padding:2pt 2pt 2pt 2pt;vertical-align:top;">NOTE  1: </td><td style="vertical-align:top;" class="Note">
      NOTE 1NOTE  1　
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
      </td></tr></table><table id="note2" class="Note"><tr><td class="example_label" style="padding:2pt 2pt 2pt 2pt;vertical-align:top;">NOTE  2: </td><td style="vertical-align:top;" class="Note">
      NOTE 2NOTE  2　
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
      </td></tr></table></div></div></body>
    OUTPUT
  end

  it "processes multi-para notes" do
    input = <<~"INPUT"
              <gb-standard xmlns="http://riboseinc.com/gbstandard">
                             <bibdata> <language>en</language> <script>Latn</script> </bibdata>
          <preface><foreword>
          <note>
          <name>NOTE</name>
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
      </note>
          </foreword></preface>
          </gb-standard>
    INPUT
    pres_output = IsoDoc::Gb::PresentationXMLConvert.new({})
      .convert("test", input, true)
    expect(strip_guid(IsoDoc::Gb::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(/^.*<body/m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_xml_equivalent_to(strip_guid(<<~"OUTPUT")).with_profile(:spec_friendly)
      <body lang="en"><div class="title-section"><p> </p></div><br/><div class="prefatory-section"><p> </p></div><br/><div class="main-section"><br/><div id="_431ef2eb-8396-9bc6-d97f-294b258fa00e" class="TOC"><h1 class="IntroTitle">Contents</h1></div><br/><div id="_7ce251a3-9631-7385-5d6c-99b32d03dde2"><h1 class="ForewordTitle">Foreword</h1><table class="Note"><tr><td class="example_label" style="padding:2pt 2pt 2pt 2pt;vertical-align:top;">NOTE: </td><td style="vertical-align:top;" class="Note">
      NOTENOTE　
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">These results are based on a study carried out on three different types of kernel.</p>
      </td></tr></table></div></div></body>
    OUTPUT
  end

  it "processes non-para notes" do
    input = <<~"INPUT"
              <gb-standard xmlns="http://riboseinc.com/gbstandard">
                             <bibdata> <language>en</language> <script>Latn</script> </bibdata>
          <preface><foreword>
          <note>
          <name>NOTE</name>
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
    pres_output = IsoDoc::Gb::PresentationXMLConvert.new({})
      .convert("test", input, true)
    expect(strip_guid(IsoDoc::Gb::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(/^.*<body/m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_xml_equivalent_to(strip_guid(<<~"OUTPUT")).with_profile(:spec_friendly)
      <body lang="en"><div class="title-section"><p> </p></div><br/><div class="prefatory-section"><p> </p></div><br/><div class="main-section"><br/><div id="_431ef2eb-8396-9bc6-d97f-294b258fa00e" class="TOC"><h1 class="IntroTitle">Contents</h1></div><br/><div id="_c92508ef-3341-a2ce-ecb5-229deec0ac8d"><h1 class="ForewordTitle">Foreword</h1><table class="Note"><tr><td class="example_label" style="padding:2pt 2pt 2pt 2pt;vertical-align:top;">NOTE: </td><td style="vertical-align:top;" class="Note">
      NOTENOTE　
      <div class="figdl"><dl><dt><p>A</p></dt><dd><p>B</p></dd></dl></div>
      <div class="ul_wrap"><ul>
      <li id="_633adc7b-e127-bf1d-3bc7-9ce93d029fbe">C</li></ul></div>
      </td></tr></table></div></div></body>
    OUTPUT
  end

  it "processes examples" do
    input = <<~"INPUT"
              <gb-standard xmlns="http://riboseinc.com/gbstandard">
                             <bibdata> <language>en</language> <script>Latn</script> </bibdata>
          <preface><foreword>
          <formula id="_be9158af-7e93-4ee2-90c5-26d31c181934"><name>1</name>
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
    pres_output = IsoDoc::Gb::PresentationXMLConvert.new({})
      .convert("test", input, true)
    expect(strip_guid(IsoDoc::Gb::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(/^.*<body/m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_xml_equivalent_to(strip_guid(<<~"OUTPUT")).with_profile(:spec_friendly)
      <body lang="en"><div class="title-section"><p> </p></div><br/><div class="prefatory-section"><p> </p></div><br/><div class="main-section"><br/><div id="_431ef2eb-8396-9bc6-d97f-294b258fa00e" class="TOC"><h1 class="IntroTitle">Contents</h1></div><br/><div id="_c0ba0d7e-b5b6-23a3-376c-15939eaec524"><h1 class="ForewordTitle">Foreword</h1><div id="_be9158af-7e93-4ee2-90c5-26d31c181934"><div class="formula">　　(1)</div>

      <p>where
      <span class="stem">(#(r)#)</span>
         is the repeatability limit.</p></div></div></div></body>
    OUTPUT
  end

    it "processes term notes" do
      input = <<~"INPUT"
                <gb-standard xmlns="http://riboseinc.com/gbstandard">
                               <bibdata> <language>en</language> <script>Latn</script> </bibdata>
            <sections>
            <terms id="_terms_and_definitions" obligation="normative"><title>1.<tab/>Terms and Definitions</title>

        <term id="paddy">
        <name>1.1.</name>
        <preferred>paddy</preferred><admitted>paddy rice</admitted>
        <definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></definition>
        <termnote id="_671a1994-4783-40d0-bc81-987d06ffb74e">
        <name>Note 1 to entry</name<
          <p id="_19830f33-e46c-42cc-94ca-a5ef101132d5">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
        </termnote>
        <termnote id="_671a1994-4783-40d0-bc81-987d06ffb74f">
        <name>Note 2 to entry</name<
        <ul><li>A</li></ul>
          <p id="_19830f33-e46c-42cc-94ca-a5ef101132d5">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
        </termnote>
        </term>
        </terms>
        </sections>
        </gb-standard>
      INPUT
      pres_output = IsoDoc::Gb::PresentationXMLConvert.new({})
        .convert("test", input, true)
      expect(strip_guid(IsoDoc::Gb::HtmlConvert.new({})
        .convert("test", pres_output, true)
        .gsub(/^.*<body/m, "<body")
        .gsub(%r{</body>.*}m, "</body>")))
        .to be_xml_equivalent_to(strip_guid(<<~"OUTPUT")).with_profile(:spec_friendly)
        <body lang="en"><div class="title-section"><p> </p></div><br/><div class="prefatory-section"><p> </p></div><br/><div class="main-section"><br/><div id="_51f71510-ce18-7db8-84af-dbaa1d3c48ac" class="TOC"><h1 class="IntroTitle">Contents</h1></div><div id="_terms_and_definitions"><h1>1　1.　Terms and Definitions</h1>

        <p class="TermNum" id="paddy">1.11.1.</p>


        <p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p>
        <table id="_671a1994-4783-40d0-bc81-987d06ffb74e" class="Note"><tr><td class="example_label" style="padding:2pt 2pt 2pt 2pt;vertical-align:top;">Note 1 to entry: </td><td style="vertical-align:top;" class="Note">
        Note 1 to entryNote 1 to entry:
          <p id="_19830f33-e46c-42cc-94ca-a5ef101132d5">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
        </td></tr></table>
        <table id="_671a1994-4783-40d0-bc81-987d06ffb74f" class="Note"><tr><td class="example_label" style="padding:2pt 2pt 2pt 2pt;vertical-align:top;">Note 2 to entry: </td><td style="vertical-align:top;" class="Note">
        Note 2 to entryNote 2 to entry:
        <div class="ul_wrap"><ul><li id="_b4a27137-02ff-852a-ce0b-821daac23f04">A</li></ul></div>
          <p id="_19830f33-e46c-42cc-94ca-a5ef101132d5">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
        </td></tr></table>

        </div></div></body>
      OUTPUT
    end
end
