# encoding: UTF-8
require "spec_helper"
require "nokogiri"
require "htmlentities"

RSpec.describe IsoDoc::Gb::HtmlConvert do
  it "processes IsoXML metadata in Chinese" do
    gbc = IsoDoc::Gb::HtmlConvert.new({})
    docxml, filename, dir = gbc.convert_init(<<~"INPUT", "test", true)
    <gb-standard xmlns="http://riboseinc.com/gbstandard">
<bibdata type="recommendation">
  <title>
    <title-intro language="en" format="plain">Cereals and pulses</title-intro>
    <title-main language="en" format="plain">Specifications and test methods</title-main>
    <title-part language="en" format="plain">Rice</title-part>
  </title>
  <title>
    <title-intro language="zh" format="plain">Cereals1</title-intro>
    <title-main language="zh" format="plain">Specifications1</title-main>
    <title-part language="zh" format="plain">Rice1</title-part>
  </title>
  <docidentifier type="gb">PreCD3 17301-1&#x2014;2016</docidentifier>
  <docidentifier type="gb-structured">
    <project-number part="1">PreCD3 17301</project-number>
  </docidentifier>
  <date type="published">
    <on>2016-01-02</on>
  </date>
  <date type="accessed">
    <on>2016-01-03</on>
  </date>
  <date type="implemented">
    <on>2016-01-04</on>
  </date>
  <date type="created">
    <on>2016-01-05</on>
  </date>
  <edition>2</edition>
  <version>
  <draft>0.1</draft>
  <revision-date>2016-05-01</revision-date>
</version>
  <contributor>
    <role type="author"/>
    <organization>
      <name>GB</name>
    </organization>
  </contributor><contributor><role type="technical-committee"/><organization><name>Food products</name></organization></contributor>
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
  <language>zh</language>
  <script>Hans</script>
  <status>
    <stage>30</stage>
    <substage>92</substage>
    <iteration>3</iteration>
  </status>
  <copyright>
    <from>2016</from>
    <owner>
      <organization>
        <name>Ministry of Agriculture</name>
      </organization>
    </owner>
  </copyright>
  <relation type="identical">
  <bibitem>
    <docidentifier>ISO 123</docidentifier>
    <title>Rice Model document</title>
  </bibitem>
  </relation>
  <ics><code>1322</code></ics>
  <ccs>A 01</ccs>
  <ccs>A 02</ccs>
  <plannumber>XYZ</plannumber>
  <gbcommittee type="provisional">Food products</gbcommittee>
  <gbtype>
    <gbscope>sector</gbscope>
    <gbprefix>NY</gbprefix>
    <gbmandate>recommended</gbmandate>
    <gbtopic>basic</gbtopic>
  </gbtype>
</bibdata>
</gb-standard>
    INPUT
    expect(htmlencode(Hash[gbc.info(docxml, nil).sort].to_s)).to be_equivalent_to <<~"OUTPUT"
    {:accesseddate=>"2016-01-03", :circulateddate=>"XXX", :committee=>"Food products", :confirmeddate=>"XXX", :copieddate=>"XXX", :createddate=>"2016-01-05", :docidentifier=>"PreCD3 17301-1&#x2014;2016", :docmaintitleen=>"Cereals and pulses&mdash;", :docmaintitlezh=>"Cereals1&nbsp;", :docnumber=>"PreCD3 17301-1&#x2014;2016", :docparttitleen=>"&mdash;Part 1:  Rice", :docparttitlezh=>"&nbsp;&#x7b2c;1&#x90e8;&#x5206;:Rice1", :docsubtitleen=>"Specifications and test methods", :docsubtitlezh=>"Specifications1", :doctitle=>"Cereals1&nbsp;Specifications1&nbsp;&#x7b2c;1&#x90e8;&#x5206;:Rice1", :doctype=>"Recommendation", :docyear=>"2016", :draft=>"0.1", :draftinfo=>"&#xff08;&#x7a3f;0.1&#x3001;2016-05-01&#xff09;", :edition=>"2", :editorialgroup=>[], :gbequivalence=>"IDT", :gbprefix=>"NY", :gbscope=>"sector", :ics=>"1322", :implementeddate=>"2016-01-04", :isostandard=>"ISO 123", :isostandardtitle=>"Rice Model document", :issueddate=>"XXX", :issuer=>"Ministry of Agriculture", :labelled_implementeddate=>"2016-01-04 &#x5b9e;&#x65bd;", :labelled_publisheddate=>"2016-01-02 &#x53d1;&#x5e03;", :libraryid_ccs=>"A 01, A 02", :libraryid_ics=>"1322", :libraryid_plan=>"XYZ", :obsoleteddate=>"XXX", :obsoletes=>nil, :obsoletes_part=>nil, :publisheddate=>"2016-01-02", :receiveddate=>"XXX", :revdate=>"2016-05-01", :sc=>"XXXX", :secretariat=>"XXXX", :stage=>30, :stageabbr=>"Pre&#x4e09;&#x6b21;&#x6807;&#x51c6;&#x8349;&#x6848;&#x5f81;&#x6c42;&#x610f;&#x89c1;&#x7a3f;", :standard_agency=>"&#x519c;&#x4e1a;&#x90e8;", :standard_class=>"&#x4e2d;&#x534e;&#x4eba;&#x6c11;&#x5171;&#x548c;&#x56fd;&#x519c;&#x4e1a;&#x884c;&#x4e1a;&#x6807;&#x51c6;", :standardclassimg=>nil, :status=>"committee-draft", :tc=>"XXXX", :transmitteddate=>"XXX", :unchangeddate=>"XXX", :unpublished=>true, :updateddate=>"XXX", :wg=>"XXXX"}
    OUTPUT
  end

  it "processes IsoXML metadata in English" do
    gbc = IsoDoc::Gb::HtmlConvert.new({})
    docxml, filename, dir = gbc.convert_init(<<~"INPUT", "test", true)
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
<bibdata type="recommendation">
  <title>
    <title-intro language="en" format="plain">Cereals and pulses</title-intro>
    <title-main language="en" format="plain">Specifications and test methods</title-main>
    <title-part language="en" format="plain">Rice</title-part>
  </title>
  <title>
    <title-intro language="zh" format="plain">Cereals1</title-intro>
    <title-main language="zh" format="plain">Specifications1</title-main>
    <title-part language="zh" format="plain">Rice1</title-part>
  </title>
  <docidentifier type="gb">PreCD3 17301-1&#x2014;2016</docidentifier>
  <docidentifier type="gb-structured">
    <project-number part="1">PreCD3 17301</project-number>
  </docidentifier>
  <date type="published">
    <on>2016-01-02</on>
  </date>
  <date type="accessed">
    <on>2016-01-03</on>
  </date>
  <date type="implemented">
    <on>2016-01-04</on>
  </date>
  <date type="created">
    <on>2016-01-05</on>
  </date>
  <edition>2</edition>
  <version>
  <draft>0.1</draft>
  <revision-date>2016-05-01</revision-date>
</version>
  <contributor>
    <role type="author"/>
    <organization>
      <name>GB</name>
    </organization>
  </contributor><contributor><role type="technical-committee"/><organization><name>Food products</name></organization></contributor>
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
    <substage>92</substage>
    <iteration>3</iteration>
  </status>
  <copyright>
    <from>2016</from>
    <owner>
      <organization>
        <name>Ministry of Agriculture</name>
      </organization>
    </owner>
  </copyright>
  <relation type="identical">
  <bibitem>
    <docidentifier>ISO 123</docidentifier>
    <title>Rice Model document</title>
  </bibitem>
  </relation>
  <ics><code>1322</code></ics>
  <ccs>A 01</ccs>
  <ccs>A 02</ccs>
  <plannumber>XYZ</plannumber>
  <gbcommittee type="provisional">Food products</gbcommittee>
  <gbtype>
    <gbscope>sector</gbscope>
    <gbprefix>NY</gbprefix>
    <gbmandate>recommended</gbmandate>
    <gbtopic>basic</gbtopic>
  </gbtype>
</bibdata><version>
  <edition>2</edition>
  <draft>0.1</draft>
  <revision-date>2016-05-01</revision-date>
</version>
</gb-standard>
    INPUT
    expect(htmlencode(Hash[gbc.info(docxml, nil).sort].to_s)).to be_equivalent_to <<~"OUTPUT"
    {:accesseddate=>"2016-01-03", :circulateddate=>"XXX", :committee=>"Food products", :confirmeddate=>"XXX", :copieddate=>"XXX", :createddate=>"2016-01-05", :docidentifier=>"PreCD3 17301-1&#x2014;2016", :docmaintitleen=>"Cereals and pulses&mdash;", :docmaintitlezh=>"Cereals1&nbsp;", :docnumber=>"PreCD3 17301-1&#x2014;2016", :docparttitleen=>"&mdash;Part 1:  Rice", :docparttitlezh=>"&nbsp;&#x7b2c;1&#x90e8;&#x5206;:Rice1", :docsubtitleen=>"Specifications and test methods", :docsubtitlezh=>"Specifications1", :doctitle=>"Cereals and pulses&mdash;Specifications and test methods&mdash;Part 1:  Rice", :doctype=>"Recommendation", :docyear=>"2016", :draft=>"0.1", :draftinfo=>" (draft 0.1, 2016-05-01)", :edition=>"2", :editorialgroup=>[], :gbequivalence=>"IDT", :gbprefix=>"NY", :gbscope=>"sector", :ics=>"1322", :implementeddate=>"2016-01-04", :isostandard=>"ISO 123", :isostandardtitle=>"Rice Model document", :issueddate=>"XXX", :issuer=>"Ministry of Agriculture", :labelled_implementeddate=>"Implementation Date: 2016-01-04", :labelled_publisheddate=>"Issuance Date: 2016-01-02", :libraryid_ccs=>"A 01, A 02", :libraryid_ics=>"1322", :libraryid_plan=>"XYZ", :obsoleteddate=>"XXX", :obsoletes=>nil, :obsoletes_part=>nil, :publisheddate=>"2016-01-02", :receiveddate=>"XXX", :revdate=>"2016-05-01", :sc=>"XXXX", :secretariat=>"XXXX", :stage=>60, :stageabbr=>"PreIS3", :standard_agency=>"Ministry of Agriculture", :standard_class=>"People's Republic of China  Agriculture  Industry Standard", :standardclassimg=>nil, :status=>"standard", :tc=>"XXXX", :transmitteddate=>"XXX", :unchangeddate=>"XXX", :unpublished=>false, :updateddate=>"XXX", :wg=>"XXXX"}
    OUTPUT

  end

  it "defaults to processesing IsoXML metadata in Chinese" do
    gbc = IsoDoc::Gb::HtmlConvert.new({})
    docxml, filename, dir = gbc.convert_init(<<~"INPUT", "test", true)
    <gb-standard xmlns="http://riboseinc.com/gbstandard">
<bibdata type="recommendation">
  <title>
    <title-intro language="en" format="plain">Cereals and pulses</title-intro>
    <title-main language="en" format="plain">Specifications and test methods</title-main>
    <title-part language="en" format="plain">Rice</title-part>
  </title>
  <title>
    <title-intro language="zh" format="plain">Cereals1</title-intro>
    <title-main language="zh" format="plain">Specifications1</title-main>
    <title-part language="zh" format="plain">Rice1</title-part>
  </title>
    <docidentifier type="gb">PreCD3 17301-1&#x2014;2016</docidentifier>
  <docidentifier type="gb-structured">
    <project-number part="1">PreCD3 17301</project-number>
  </docidentifier>
  <date type="published">
    <on>2016-01-02</on>
  </date>
  <date type="accessed">
    <on>2016-01-03</on>
  </date>
  <date type="implemented">
    <on>2016-01-04</on>
  </date>
  <date type="created">
    <on>2016-01-05</on>
  </date>
  <contributor>
    <role type="author"/>
    <organization>
      <name>GB</name>
    </organization>
  </contributor><contributor><role type="technical-committee"/><organization><name>Food products</name></organization></contributor>
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
  <language>tlh</language>
  <script>Hans</script>
  <status>
    <stage>30</stage>
    <substage>92</substage>
    <iteration>3</iteration>
  </status>
  <copyright>
    <from>2016</from>
    <owner>
      <organization>
        <name>Ministry of Agriculture</name>
      </organization>
    </owner>
  </copyright>
  <relation type="identical">
  <bibitem>
    <docidentifier>ISO 123</docidentifier>
    <title>Rice Model document</title>
  </bibitem>
  </relation>
  <ics><code>1322</code></ics>
  <ccs>A 01</ccs>
  <ccs>A 02</ccs>
  <plannumber>XYZ</plannumber>
  <gbcommittee type="provisional">Food products</gbcommittee>
  <gbtype>
    <gbscope>sector</gbscope>
    <gbprefix>NY</gbprefix>
    <gbmandate>recommended</gbmandate>
    <gbtopic>basic</gbtopic>
  </gbtype>
</bibdata>
</gb-standard>
    INPUT
    expect(htmlencode(Hash[gbc.info(docxml, nil).sort].to_s)).to be_equivalent_to <<~"OUTPUT"
    {:accesseddate=>"2016-01-03", :circulateddate=>"XXX", :committee=>"Food products", :confirmeddate=>"XXX", :copieddate=>"XXX", :createddate=>"2016-01-05", :docidentifier=>"PreCD3 17301-1&#x2014;2016", :docmaintitleen=>"Cereals and pulses&mdash;", :docmaintitlezh=>"Cereals1&nbsp;", :docnumber=>"PreCD3 17301-1&#x2014;2016", :docparttitleen=>"&mdash;Part 1:  Rice", :docparttitlezh=>"&nbsp;&#x7b2c;1&#x90e8;&#x5206;:Rice1", :docsubtitleen=>"Specifications and test methods", :docsubtitlezh=>"Specifications1", :doctitle=>"Cereals1&nbsp;Specifications1&nbsp;&#x7b2c;1&#x90e8;&#x5206;:Rice1", :doctype=>"Recommendation", :docyear=>"2016", :draft=>nil, :draftinfo=>"", :edition=>nil, :editorialgroup=>[], :gbequivalence=>"IDT", :gbprefix=>"NY", :gbscope=>"sector", :ics=>"1322", :implementeddate=>"2016-01-04", :isostandard=>"ISO 123", :isostandardtitle=>"Rice Model document", :issueddate=>"XXX", :issuer=>"Ministry of Agriculture", :labelled_implementeddate=>"2016-01-04 &#x5b9e;&#x65bd;", :labelled_publisheddate=>"2016-01-02 &#x53d1;&#x5e03;", :libraryid_ccs=>"A 01, A 02", :libraryid_ics=>"1322", :libraryid_plan=>"XYZ", :obsoleteddate=>"XXX", :obsoletes=>nil, :obsoletes_part=>nil, :publisheddate=>"2016-01-02", :receiveddate=>"XXX", :revdate=>nil, :sc=>"XXXX", :secretariat=>"XXXX", :stage=>30, :stageabbr=>"&#x4e09;&#x6b21;&#x6807;&#x51c6;&#x8349;&#x6848;&#x5f81;&#x6c42;&#x610f;&#x89c1;&#x7a3f;", :standard_agency=>"&#x519c;&#x4e1a;&#x90e8;", :standard_class=>"&#x4e2d;&#x534e;&#x4eba;&#x6c11;&#x5171;&#x548c;&#x56fd;&#x519c;&#x4e1a;&#x884c;&#x4e1a;&#x6807;&#x51c6;", :standardclassimg=>nil, :status=>"committee-draft", :tc=>"XXXX", :transmitteddate=>"XXX", :unchangeddate=>"XXX", :unpublished=>true, :updateddate=>"XXX", :wg=>"XXXX"}
    OUTPUT
  end


  it "processes equivalent ISO doc; no part number; draft > 1; no iteration; published status; local scope" do
    gbc = IsoDoc::Gb::HtmlConvert.new({})
    docxml, filename, dir = gbc.convert_init(<<~"INPUT", "test", true)
    <gb-standard xmlns="http://riboseinc.com/gbstandard">
<bibdata type="recommendation">
  <title>
    <title-intro language="en" format="plain">Cereals and pulses</title-intro>
    <title-main language="en" format="plain">Specifications and test methods</title-main>
    <title-part language="en" format="plain">Rice</title-part>
  </title>
  <title>
    <title-intro language="zh" format="plain">Cereals1</title-intro>
    <title-main language="zh" format="plain">Specifications1</title-main>
    <title-part language="zh" format="plain">Rice1</title-part>
  </title>
  <docidentifier type="gb">17301&#x2014;2016</docidentifier>
  <docidentifier type="gb-structured">
    <project-number>17301</project-number>
  </docidentifier>
  <date type="published">
    <on>2016-01-02</on>
  </date>
  <date type="accessed">
    <on>2016-01-03</on>
  </date>
  <date type="implemented">
    <on>2016-01-04</on>
  </date>
  <date type="created">
    <on>2016-01-05</on>
  </date>
  <contributor>
    <role type="author"/>
    <organization>
      <name>GB</name>
    </organization>
  </contributor><contributor><role type="technical-committee"/><organization><name>Food products</name></organization></contributor>
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
  <language>zh</language>
  <script>Hans</script>
  <status>
    <stage>60</stage>
    <substage>92</substage>
  </status>
  <copyright>
    <from>2016</from>
    <owner>
      <organization>
        <name>Ministry of Agriculture</name>
      </organization>
    </owner>
  </copyright>
  <relation type="equivalent">
  <bibitem>
    <docidentifier>ISO 123</docidentifier>
    <title>Rice Model document</title>
  </bibitem>
  </relation>
  <ics><code>1322</code></ics>
  <ccs>A 01</ccs>
  <ccs>A 02</ccs>
  <plannumber>XYZ</plannumber>
  <gbcommittee type="provisional">Food products</gbcommittee>
  <gbtype>
    <gbscope>local</gbscope>
    <gbprefix>81</gbprefix>
    <gbmandate>recommended</gbmandate>
    <gbtopic>basic</gbtopic>
  </gbtype>
</bibdata>
</gb-standard>
    INPUT
    expect(htmlencode(Hash[gbc.info(docxml, nil).sort].to_s)).to be_equivalent_to <<~"OUTPUT"
    {:accesseddate=>"2016-01-03", :circulateddate=>"XXX", :committee=>"Food products", :confirmeddate=>"XXX", :copieddate=>"XXX", :createddate=>"2016-01-05", :docidentifier=>"17301&#x2014;2016", :docmaintitleen=>"Cereals and pulses&mdash;", :docmaintitlezh=>"Cereals1&nbsp;", :docnumber=>"17301&#x2014;2016", :docparttitleen=>"&mdash; Rice", :docparttitlezh=>"&nbsp;Rice1", :docsubtitleen=>"Specifications and test methods", :docsubtitlezh=>"Specifications1", :doctitle=>"Cereals1&nbsp;Specifications1&nbsp;Rice1", :doctype=>"Recommendation", :docyear=>"2016", :draft=>nil, :draftinfo=>"", :edition=>nil, :editorialgroup=>[], :gbequivalence=>"MOD", :gblocalcode=>"81", :gbprefix=>"DB", :gbscope=>"local", :ics=>"1322", :implementeddate=>"2016-01-04", :isostandard=>"ISO 123", :isostandardtitle=>"Rice Model document", :issueddate=>"XXX", :issuer=>"Ministry of Agriculture", :labelled_implementeddate=>"2016-01-04 &#x5b9e;&#x65bd;", :labelled_publisheddate=>"2016-01-02 &#x53d1;&#x5e03;", :libraryid_ccs=>"A 01, A 02", :libraryid_ics=>"1322", :libraryid_plan=>"XYZ", :obsoleteddate=>"XXX", :obsoletes=>nil, :obsoletes_part=>nil, :publisheddate=>"2016-01-02", :receiveddate=>"XXX", :revdate=>nil, :sc=>"XXXX", :secretariat=>"XXXX", :stage=>60, :stageabbr=>"&#x56fd;&#x5bb6;&#x6807;&#x51c6;", :standard_agency=>"&#x9999;&#x6e2f;&#x7279;&#x522b;&#x884c;&#x653f;&#x533a;&#x8d28;&#x91cf;&#x6280;&#x672f;&#x68c0;&#x6d4b;&#x5c40;", :standard_class=>"&#x9999;&#x6e2f;&#x7279;&#x522b;&#x884c;&#x653f;&#x533a;&#x5730;&#x65b9;&#x6807;&#x51c6;", :standardclassimg=>nil, :status=>"standard", :tc=>"XXXX", :transmitteddate=>"XXX", :unchangeddate=>"XXX", :unpublished=>false, :updateddate=>"XXX", :wg=>"XXXX"}
    OUTPUT
  end

  it "processes non-equivalent ISO doc; no part number; draft > 1; no iteration; published status; enterprise scope" do
    gbc = IsoDoc::Gb::HtmlConvert.new({})
    docxml, filename, dir = gbc.convert_init(<<~"INPUT", "test", true)
    <gb-standard xmlns="http://riboseinc.com/gbstandard">
<bibdata type="recommendation">
  <title>
    <title-intro language="en" format="plain">Cereals and pulses</title-intro>
    <title-main language="en" format="plain">Specifications and test methods</title-main>
    <title-part language="en" format="plain">Rice</title-part>
  </title>
  <title>
    <title-intro language="zh" format="plain">Cereals1</title-intro>
    <title-main language="zh" format="plain">Specifications1</title-main>
    <title-part language="zh" format="plain">Rice1</title-part>
  </title>
    <docidentifier type="gb">17301&#x2014;2016</docidentifier>
  <docidentifier type="gb-structured">
    <project-number>17301</project-number>
  </docidentifier>
  <date type="published">
    <on>2016-01-02</on>
  </date>
  <date type="accessed">
    <on>2016-01-03</on>
  </date>
  <date type="implemented">
    <on>2016-01-04</on>
  </date>
  <date type="created">
    <on>2016-01-05</on>
  </date>
  <contributor>
    <role type="author"/>
    <organization>
      <name>GB</name>
    </organization>
  </contributor><contributor><role type="technical-committee"/><organization><name>Food products</name></organization></contributor>
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
  <language>zh</language>
  <script>Hans</script>
  <status>
    <stage>60</stage>
    <substage>92</substage>
  </status>
  <copyright>
    <from>2016</from>
    <owner>
      <organization>
        <name>Ministry of Agriculture</name>
      </organization>
    </owner>
  </copyright>
  <relation type="nonequivalent">
  <bibitem>
    <docidentifier>ISO 123</docidentifier>
    <title>Rice Model document</title>
  </bibitem>
  </relation>
  <ics><code>1322</code></ics>
  <ccs>A 01</ccs>
  <ccs>A 02</ccs>
  <plannumber>XYZ</plannumber>
  <gbcommittee type="provisional">Food products</gbcommittee>
  <gbtype>
    <gbscope>enterprise</gbscope>
    <gbprefix>ABC</gbprefix>
    <gbmandate>recommended</gbmandate>
    <gbtopic>basic</gbtopic>
  </gbtype>
</bibdata>
</gb-standard>
    INPUT
    expect(htmlencode(Hash[gbc.info(docxml, nil).sort].to_s)).to be_equivalent_to <<~"OUTPUT"
    {:accesseddate=>"2016-01-03", :circulateddate=>"XXX", :committee=>"Food products", :confirmeddate=>"XXX", :copieddate=>"XXX", :createddate=>"2016-01-05", :docidentifier=>"17301&#x2014;2016", :docmaintitleen=>"Cereals and pulses&mdash;", :docmaintitlezh=>"Cereals1&nbsp;", :docnumber=>"17301&#x2014;2016", :docparttitleen=>"&mdash; Rice", :docparttitlezh=>"&nbsp;Rice1", :docsubtitleen=>"Specifications and test methods", :docsubtitlezh=>"Specifications1", :doctitle=>"Cereals1&nbsp;Specifications1&nbsp;Rice1", :doctype=>"Recommendation", :docyear=>"2016", :draft=>nil, :draftinfo=>"", :edition=>nil, :editorialgroup=>[], :gbequivalence=>"NEQ", :gbprefix=>"ABC", :gbscope=>"enterprise", :ics=>"1322", :implementeddate=>"2016-01-04", :isostandard=>"ISO 123", :isostandardtitle=>"Rice Model document", :issueddate=>"XXX", :issuer=>"Ministry of Agriculture", :labelled_implementeddate=>"2016-01-04 &#x5b9e;&#x65bd;", :labelled_publisheddate=>"2016-01-02 &#x53d1;&#x5e03;", :libraryid_ccs=>"A 01, A 02", :libraryid_ics=>"1322", :libraryid_plan=>"XYZ", :obsoleteddate=>"XXX", :obsoletes=>nil, :obsoletes_part=>nil, :publisheddate=>"2016-01-02", :receiveddate=>"XXX", :revdate=>nil, :sc=>"XXXX", :secretariat=>"XXXX", :stage=>60, :stageabbr=>"&#x56fd;&#x5bb6;&#x6807;&#x51c6;", :standard_agency=>"Ministry of Agriculture", :standard_class=>"Ministry of Agriculture&#x4f01;&#x4e1a;&#x6807;&#x51c6;", :standardclassimg=>nil, :status=>"standard", :tc=>"XXXX", :transmitteddate=>"XXX", :unchangeddate=>"XXX", :unpublished=>false, :updateddate=>"XXX", :wg=>"XXXX"}
    OUTPUT
  end

  it "processes non-equivalent ISO doc; no part number; draft > 1; no iteration; published status; national scope" do
    gbc = IsoDoc::Gb::HtmlConvert.new({})
    docxml, filename, dir = gbc.convert_init(<<~"INPUT", "test", true)
    <gb-standard xmlns="http://riboseinc.com/gbstandard">
<bibdata type="recommendation">
  <title>
    <title-intro language="en" format="plain">Cereals and pulses</title-intro>
    <title-main language="en" format="plain">Specifications and test methods</title-main>
    <title-part language="en" format="plain">Rice</title-part>
  </title>
  <title>
    <title-intro language="zh" format="plain">Cereals1</title-intro>
    <title-main language="zh" format="plain">Specifications1</title-main>
    <title-part language="zh" format="plain">Rice1</title-part>
  </title>
    <docidentifier type="gb">17301&#x2014;2016</docidentifier>
  <docidentifier type="gb-structured">
    <project-number>17301</project-number>
  </docidentifier>
  <date type="published">
    <on>2016-01-02</on>
  </date>
  <date type="accessed">
    <on>2016-01-03</on>
  </date>
  <date type="implemented">
    <on>2016-01-04</on>
  </date>
  <date type="created">
    <on>2016-01-05</on>
  </date>
  <contributor>
    <role type="author"/>
    <organization>
      <name>GB</name>
    </organization>
  </contributor><contributor><role type="technical-committee"/><organization><name>Food products</name></organization></contributor>
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
  <language>zh</language>
  <script>Hans</script>
  <status>
    <stage>60</stage>
    <substage>92</substage>
  </status>
  <copyright>
    <from>2016</from>
    <owner>
      <organization>
        <name>Ministry of Agriculture</name>
      </organization>
    </owner>
  </copyright>
  <relation type="nonequivalent">
  <bibitem>
    <docidentifier>ISO 123</docidentifier>
    <title>Rice Model document</title>
  </bibitem>
  </relation>
  <ics><code>1322</code></ics>
  <ccs>A 01</ccs>
  <ccs>A 02</ccs>
  <plannumber>XYZ</plannumber>
  <gbcommittee type="provisional">Food products</gbcommittee>
  <gbtype>
    <gbscope>national</gbscope>
    <gbprefix>GB</gbprefix>
    <gbmandate>recommended</gbmandate>
    <gbtopic>basic</gbtopic>
  </gbtype>
</bibdata>
</gb-standard>
    INPUT
    expect(htmlencode(Hash[gbc.info(docxml, nil).sort].to_s)).to be_equivalent_to <<~"OUTPUT"
    {:accesseddate=>"2016-01-03", :circulateddate=>"XXX", :committee=>"Food products", :confirmeddate=>"XXX", :copieddate=>"XXX", :createddate=>"2016-01-05", :docidentifier=>"17301&#x2014;2016", :docmaintitleen=>"Cereals and pulses&mdash;", :docmaintitlezh=>"Cereals1&nbsp;", :docnumber=>"17301&#x2014;2016", :docparttitleen=>"&mdash; Rice", :docparttitlezh=>"&nbsp;Rice1", :docsubtitleen=>"Specifications and test methods", :docsubtitlezh=>"Specifications1", :doctitle=>"Cereals1&nbsp;Specifications1&nbsp;Rice1", :doctype=>"Recommendation", :docyear=>"2016", :draft=>nil, :draftinfo=>"", :edition=>nil, :editorialgroup=>[], :gbequivalence=>"NEQ", :gbprefix=>"GB", :gbscope=>"national", :ics=>"1322", :implementeddate=>"2016-01-04", :isostandard=>"ISO 123", :isostandardtitle=>"Rice Model document", :issueddate=>"XXX", :issuer=>"Ministry of Agriculture", :labelled_implementeddate=>"2016-01-04 &#x5b9e;&#x65bd;", :labelled_publisheddate=>"2016-01-02 &#x53d1;&#x5e03;", :libraryid_ccs=>"A 01, A 02", :libraryid_ics=>"1322", :libraryid_plan=>"XYZ", :obsoleteddate=>"XXX", :obsoletes=>nil, :obsoletes_part=>nil, :publisheddate=>"2016-01-02", :receiveddate=>"XXX", :revdate=>nil, :sc=>"XXXX", :secretariat=>"XXXX", :stage=>60, :stageabbr=>"&#x56fd;&#x5bb6;&#x6807;&#x51c6;", :standard_agency=>["&#x4e2d;&#x534e;&#x4eba;&#x6c11;&#x5171;&#x548c;&#x56fd;&#x56fd;&#x5bb6;&#x8d28;&#x91cf;&#x76d1;&#x7763;&#x68c0;&#x9a8c;&#x68c0;&#x75ab;&#x603b;&#x5c40;", "&#x4e2d;&#x56fd;&#x56fd;&#x5bb6;&#x6807;&#x51c6;&#x5316;&#x7ba1;&#x7406;&#x59d4;&#x5458;&#x4f1a;"], :standard_class=>"&#x4e2d;&#x534e;&#x4eba;&#x6c11;&#x5171;&#x548c;&#x56fd;&#x56fd;&#x5bb6;&#x6807;&#x51c6;", :standardclassimg=>nil, :status=>"standard", :tc=>"XXXX", :transmitteddate=>"XXX", :unchangeddate=>"XXX", :unpublished=>false, :updateddate=>"XXX", :wg=>"XXXX"}
    OUTPUT
  end

  it "processes non-equivalent ISO doc; no part number; draft > 1; no iteration; published status; social scope" do
    gbc = IsoDoc::Gb::HtmlConvert.new({})
    docxml, filename, dir = gbc.convert_init(<<~"INPUT", "test", true)
    <gb-standard xmlns="http://riboseinc.com/gbstandard">
<bibdata type="recommendation">
  <title>
    <title-intro language="en" format="plain">Cereals and pulses</title-intro>
    <title-main language="en" format="plain">Specifications and test methods</title-main>
    <title-part language="en" format="plain">Rice</title-part>
  </title>
  <title>
    <title-intro language="zh" format="plain">Cereals1</title-intro>
    <title-main language="zh" format="plain">Specifications1</title-main>
    <title-part language="zh" format="plain">Rice1</title-part>
  </title>
    <docidentifier type="gb">17301&#x2014;2016</docidentifier>
  <docidentifier type="gb-structured">
    <project-number>17301</project-number>
  </docidentifier>
  <date type="published">
    <on>2016-01-02</on>
  </date>
  <date type="accessed">
    <on>2016-01-03</on>
  </date>
  <date type="implemented">
    <on>2016-01-04</on>
  </date>
  <date type="created">
    <on>2016-01-05</on>
  </date>
  <contributor>
    <role type="author"/>
    <organization>
      <name>GB</name>
    </organization>
  </contributor><contributor><role type="technical-committee"/><organization><name>Food products</name></organization></contributor>
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
  <language>zh</language>
  <script>Hans</script>
  <status>
    <stage>60</stage>
    <substage>92</substage>
  </status>
  <copyright>
    <from>2016</from>
    <owner>
      <organization>
        <name>Ministry of Agriculture</name>
      </organization>
    </owner>
  </copyright>
  <relation type="nonequivalent">
  <bibitem>
    <docidentifier>ISO 123</docidentifier>
    <title>Rice Model document</title>
  </bibitem>
  </relation>
  <ics><code>1322</code></ics>
  <ccs>A 01</ccs>
  <ccs>A 02</ccs>
  <plannumber>XYZ</plannumber>
  <gbcommittee type="provisional">Food products</gbcommittee>
  <gbtype>
    <gbscope>social-group</gbscope>
    <gbprefix>BBB</gbprefix>
    <gbmandate>recommended</gbmandate>
    <gbtopic>basic</gbtopic>
  </gbtype>
</bibdata>
</gb-standard>
    INPUT
    expect(htmlencode(Hash[gbc.info(docxml, nil).sort].to_s)).to be_equivalent_to <<~"OUTPUT"
    {:accesseddate=>"2016-01-03", :circulateddate=>"XXX", :committee=>"Food products", :confirmeddate=>"XXX", :copieddate=>"XXX", :createddate=>"2016-01-05", :docidentifier=>"17301&#x2014;2016", :docmaintitleen=>"Cereals and pulses&mdash;", :docmaintitlezh=>"Cereals1&nbsp;", :docnumber=>"17301&#x2014;2016", :docparttitleen=>"&mdash; Rice", :docparttitlezh=>"&nbsp;Rice1", :docsubtitleen=>"Specifications and test methods", :docsubtitlezh=>"Specifications1", :doctitle=>"Cereals1&nbsp;Specifications1&nbsp;Rice1", :doctype=>"Recommendation", :docyear=>"2016", :draft=>nil, :draftinfo=>"", :edition=>nil, :editorialgroup=>[], :gbequivalence=>"NEQ", :gbprefix=>"BBB", :gbscope=>"social-group", :ics=>"1322", :implementeddate=>"2016-01-04", :isostandard=>"ISO 123", :isostandardtitle=>"Rice Model document", :issueddate=>"XXX", :issuer=>"Ministry of Agriculture", :labelled_implementeddate=>"2016-01-04 &#x5b9e;&#x65bd;", :labelled_publisheddate=>"2016-01-02 &#x53d1;&#x5e03;", :libraryid_ccs=>"A 01, A 02", :libraryid_ics=>"1322", :libraryid_plan=>"XYZ", :obsoleteddate=>"XXX", :obsoletes=>nil, :obsoletes_part=>nil, :publisheddate=>"2016-01-02", :receiveddate=>"XXX", :revdate=>nil, :sc=>"XXXX", :secretariat=>"XXXX", :stage=>60, :stageabbr=>"&#x56fd;&#x5bb6;&#x6807;&#x51c6;", :standard_agency=>"Ministry of Agriculture", :standard_class=>"&#x56e2;&#x4f53;&#x6807;&#x51c6;", :standardclassimg=>nil, :status=>"standard", :tc=>"XXXX", :transmitteddate=>"XXX", :unchangeddate=>"XXX", :unpublished=>false, :updateddate=>"XXX", :wg=>"XXXX"}
    OUTPUT
  end


end
