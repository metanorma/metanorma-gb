# encoding: UTF-8
require "spec_helper"
require "nokogiri"
require "htmlentities"

RSpec.describe IsoDoc::Gb::HtmlConvert do
  it "processes IsoXML metadata in Chinese" do
    gbc = IsoDoc::Gb::HtmlConvert.new({})
    docxml, filename, dir = gbc.convert_init(<<~"INPUT", "test", true)
    <gb-standard xmlns="http://riboseinc.com/gbstandard">
<bibdata type="standard">
    <title type="title-intro" language="en" format="plain">Cereals and pulses</title>
    <title type="title-main" language="en" format="plain">Specifications and test methods</title>
    <title type="title-part" language="en" format="plain">Rice</title>
    <title type="title-intro" language="zh" format="plain">Cereals1</title>
    <title type="title-main" language="zh" format="plain">Specifications1</title>
    <title type="title-part" language="zh" format="plain">Rice1</title>
  <docidentifier type="gb">PreCD3 17301-1&#x2014;2016</docidentifier>
  <docnumber>17301</docidentifier>
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
    <stage abbreviation="CD">30</stage>
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
  <relation type="adoptedFrom">
  <description>identical</description>
  <bibitem>
    <docidentifier>ISO 123</docidentifier>
    <title>Rice Model document</title>
  </bibitem>
  </relation>
  <ext>
  <doctype>recommendation</doctype>
  <ics><code>1322</code></ics>
  <structuredidentifier>
    <project-number part="1">PreCD3 17301</project-number>
  </structuredidentifier>
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
  </ext>
</bibdata>
</gb-standard>
    INPUT
    expect(htmlencode(metadata(gbc.info(docxml, nil)).to_s)).to be_equivalent_to htmlencode(<<~"OUTPUT")
{:accesseddate=>"2016-01-03",
:circulateddate=>"XXX",
:committee=>"Food products",
:confirmeddate=>"XXX",
:copieddate=>"XXX",
:createddate=>"2016-01-05",
:docidentifier=>"PreCD3 17301-1&#x2014;2016",
:docmaintitleen=>"Cereals and pulses&mdash;",
:docmaintitlezh=>"Cereals1&nbsp;",
:docnumber=>"PreCD3 17301-1&#x2014;2016",
:docnumeric=>"17301",
:docparttitleen=>"&mdash;Part 1:  Rice",
:docparttitlezh=>"&nbsp;&#x7b2c;1&#x90e8;&#x5206;:Rice1",
:docsubtitleen=>"Specifications and test methods",
:docsubtitlezh=>"Specifications1",
:doctitle=>"Cereals1&nbsp;Specifications1&nbsp;&#x7b2c;1&#x90e8;&#x5206;:Rice1",
:doctype=>"Recommendation",
:doctype_display=>"Recommendation",
:docyear=>"2016",
:draft=>"0.1",
:draftinfo=>"&#xff08;&#x7a3f;0.1&#x3001;2016-05-01&#xff09;",
:edition=>"2",
:gbequivalence=>"IDT",
:gbprefix=>"NY",
:gbscope=>"sector",
:ics=>"1322",
:implementeddate=>"2016-01-04",
:isostandard=>"ISO 123",
:isostandardtitle=>"Rice Model document",
:issueddate=>"XXX",
:issuer=>"Ministry of Agriculture",
:labelled_implementeddate=>"2016-01-04 &#x5b9e;&#x65bd;",
:labelled_publisheddate=>"2016-01-02 &#x53d1;&#x5e03;",
:lang=>"zh",
:libraryid_ccs=>"A 01, A 02",
:libraryid_plan=>"XYZ",
:obsoleteddate=>"XXX",
:publisheddate=>"2016-01-02",
:receiveddate=>"XXX",
:revdate=>"2016-05-01",
:revdate_monthyear=>"&#x4e94;&#x6708;2016",
:sc=>"XXXX",
:script=>"Hans",
:secretariat=>"XXX",
:stage=>30,
:stageabbr=>"CD",
:standard_agency=>"&#x519c;&#x4e1a;&#x90e8;",
:standard_class=>"&#x4e2d;&#x534e;&#x4eba;&#x6c11;&#x5171;&#x548c;&#x56fd;&#x519c;&#x4e1a;&#x884c;&#x4e1a;&#x6807;&#x51c6;",
:status=>"committee-draft",
:statusabbr=>"Pre&#x4e09;&#x6b21;&#x6807;&#x51c6;&#x8349;&#x6848;&#x5f81;&#x6c42;&#x610f;&#x89c1;&#x7a3f;",
:tc=>"XXXX",
:transmitteddate=>"XXX",
:unchangeddate=>"XXX",
:unpublished=>true,
:updateddate=>"XXX",
:vote_endeddate=>"XXX",
:vote_starteddate=>"XXX",
:wg=>"XXXX"}
    OUTPUT
  end

  it "processes IsoXML metadata in English" do
    gbc = IsoDoc::Gb::HtmlConvert.new({})
    docxml, filename, dir = gbc.convert_init(<<~"INPUT", "test", true)
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
<bibdata type="standard">
    <title type="title-intro" language="en" format="plain">Cereals and pulses</title>
    <title type="title-main" language="en" format="plain">Specifications and test methods</title>
    <title type="title-part" language="en" format="plain">Rice</title>
    <title type="title-intro" language="zh" format="plain">Cereals1</title>
    <title type="title-main" language="zh" format="plain">Specifications1</title>
    <title type="title-part" language="zh" format="plain">Rice1</title>
  <docidentifier type="gb">PreCD3 17301-1&#x2014;2016</docidentifier>
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
    <stage abbreviation="IS">60</stage>
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
  <relation type="adoptedFrom">
  <description>identical</description>
  <bibitem>
    <docidentifier>ISO 123</docidentifier>
    <title>Rice Model document</title>
  </bibitem>
  </relation>
  <ext>
  <doctype>recommendation</doctype>
  <structuredidentifier>
    <project-number part="1">PreCD3 17301</project-number>
  </structuredidentifier>
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
  </ext>
</bibdata>
</gb-standard>
    INPUT
    expect(htmlencode(metadata(gbc.info(docxml, nil)).to_s)).to be_equivalent_to htmlencode(<<~"OUTPUT")
{:accesseddate=>"2016-01-03",
:circulateddate=>"XXX",
:committee=>"Food products",
:confirmeddate=>"XXX",
:copieddate=>"XXX",
:createddate=>"2016-01-05",
:docidentifier=>"PreCD3 17301-1&#x2014;2016",
:docmaintitleen=>"Cereals and pulses&mdash;",
:docmaintitlezh=>"Cereals1&nbsp;",
:docnumber=>"PreCD3 17301-1&#x2014;2016",
:docparttitleen=>"&mdash;Part 1:  Rice",
:docparttitlezh=>"&nbsp;&#x7b2c;1&#x90e8;&#x5206;:Rice1",
:docsubtitleen=>"Specifications and test methods",
:docsubtitlezh=>"Specifications1",
:doctitle=>"Cereals and pulses&mdash;Specifications and test methods&mdash;Part 1:  Rice",
:doctype=>"Recommendation",
:doctype_display=>"Recommendation",
:docyear=>"2016",
:draft=>"0.1",
:draftinfo=>" (draft 0.1, 2016-05-01)",
:edition=>"2",
:gbequivalence=>"IDT",
:gbprefix=>"NY",
:gbscope=>"sector",
:implementeddate=>"2016-01-04",
:isostandard=>"ISO 123",
:isostandardtitle=>"Rice Model document",
:issueddate=>"XXX",
:issuer=>"Ministry of Agriculture",
:labelled_implementeddate=>"Implementation Date: 2016-01-04",
:labelled_publisheddate=>"Issuance Date: 2016-01-02",
:lang=>"en",
:libraryid_ccs=>"A 01, A 02",
:libraryid_plan=>"XYZ",
:obsoleteddate=>"XXX",
:publisheddate=>"2016-01-02",
:receiveddate=>"XXX",
:revdate=>"2016-05-01",
:revdate_monthyear=>"May 2016",
:sc=>"XXXX",
:script=>"Latn",
:secretariat=>"XXX",
:stage=>60,
:standard_agency=>"Ministry of Agriculture",
:standard_class=>"People's Republic of China  Agriculture  Industry Standard",
:status=>"standard",
:statusabbr=>"PreIS",
:tc=>"XXXX",
:transmitteddate=>"XXX",
:unchangeddate=>"XXX",
:unpublished=>false,
:updateddate=>"XXX",
:vote_endeddate=>"XXX",
:vote_starteddate=>"XXX",
:wg=>"XXXX"}
    OUTPUT

  end

  it "defaults to processesing IsoXML metadata in Chinese" do
    gbc = IsoDoc::Gb::HtmlConvert.new({})
    docxml, filename, dir = gbc.convert_init(<<~"INPUT", "test", true)
    <gb-standard xmlns="http://riboseinc.com/gbstandard">
<bibdata type="standard">
    <title type="title-intro" language="en" format="plain">Cereals and pulses</title>
    <title type="title-main" language="en" format="plain">Specifications and test methods</title>
    <title type="title-part" language="en" format="plain">Rice</title>
    <title type="title-intro" language="zh" format="plain">Cereals1</title>
    <title type="title-main" language="zh" format="plain">Specifications1</title>
    <title type="title-part" language="zh" format="plain">Rice1</title>
    <docidentifier type="gb">PreCD3 17301-1&#x2014;2016</docidentifier>
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
  <language>tlh</language>
  <script>Hans</script>
  <status>
    <stage abbreviation="CD">30</stage>
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
  <relation type="adoptedFrom">
  <description>identical</description>
  <bibitem>
    <docidentifier>ISO 123</docidentifier>
    <title>Rice Model document</title>
  </bibitem>
  </relation>
  <ext>
  <doctype>recommendation</doctype>
  <structuredidentifier>
    <project-number part="1">PreCD3 17301</project-number>
  </structuredidentifier>
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
  </ext>
</bibdata>
</gb-standard>
    INPUT
    expect(htmlencode(metadata(gbc.info(docxml, nil)).to_s)).to be_equivalent_to htmlencode(<<~"OUTPUT")
{:accesseddate=>"2016-01-03",
:circulateddate=>"XXX",
:committee=>"Food products",
:confirmeddate=>"XXX",
:copieddate=>"XXX",
:createddate=>"2016-01-05",
:docidentifier=>"PreCD3 17301-1&#x2014;2016",
:docmaintitleen=>"Cereals and pulses&mdash;",
:docmaintitlezh=>"Cereals1&nbsp;",
:docnumber=>"PreCD3 17301-1&#x2014;2016",
:docparttitleen=>"&mdash;Part 1:  Rice",
:docparttitlezh=>"&nbsp;&#x7b2c;1&#x90e8;&#x5206;:Rice1",
:docsubtitleen=>"Specifications and test methods",
:docsubtitlezh=>"Specifications1",
:doctitle=>"Cereals1&nbsp;Specifications1&nbsp;&#x7b2c;1&#x90e8;&#x5206;:Rice1",
:doctype=>"Recommendation",
:doctype_display=>"Recommendation",
:docyear=>"2016",
:draft=>"0.1",
:draftinfo=>"&#xff08;draft0.1&#x3001;2016-05-01&#xff09;",
:gbequivalence=>"IDT",
:gbprefix=>"NY",
:gbscope=>"sector",
:implementeddate=>"2016-01-04",
:isostandard=>"ISO 123",
:isostandardtitle=>"Rice Model document",
:issueddate=>"XXX",
:issuer=>"Ministry of Agriculture",
:labelled_implementeddate=>"2016-01-04 &#x5b9e;&#x65bd;",
:labelled_publisheddate=>"2016-01-02 &#x53d1;&#x5e03;",
:lang=>"zh",
:libraryid_ccs=>"A 01, A 02",
:libraryid_plan=>"XYZ",
:obsoleteddate=>"XXX",
:publisheddate=>"2016-01-02",
:receiveddate=>"XXX",
:revdate=>"2016-05-01",
:revdate_monthyear=>"May2016",
:sc=>"XXXX",
:script=>"Hans",
:secretariat=>"XXX",
:stage=>30,
:stageabbr=>"CD",
:standard_agency=>"&#x519c;&#x4e1a;&#x90e8;",
:standard_class=>"&#x4e2d;&#x534e;&#x4eba;&#x6c11;&#x5171;&#x548c;&#x56fd;&#x519c;&#x4e1a;&#x884c;&#x4e1a;&#x6807;&#x51c6;",
:status=>"committee-draft",
:statusabbr=>"Pre&#x4e09;&#x6b21;&#x6807;&#x51c6;&#x8349;&#x6848;&#x5f81;&#x6c42;&#x610f;&#x89c1;&#x7a3f;",
:tc=>"XXXX",
:transmitteddate=>"XXX",
:unchangeddate=>"XXX",
:unpublished=>true,
:updateddate=>"XXX",
:vote_endeddate=>"XXX",
:vote_starteddate=>"XXX",
:wg=>"XXXX"}
    OUTPUT
  end

  it "processes equivalent ISO doc; no part number; draft > 1; no iteration; published status; local scope" do
    gbc = IsoDoc::Gb::HtmlConvert.new({})
    docxml, filename, dir = gbc.convert_init(<<~"INPUT", "test", true)
    <gb-standard xmlns="http://riboseinc.com/gbstandard">
<bibdata type="standard">
    <title type="title-intro" language="en" format="plain">Cereals and pulses</title>
    <title type="title-main" language="en" format="plain">Specifications and test methods</title>
    <title type="title-part" language="en" format="plain">Rice</title>
    <title type="title-intro" language="zh" format="plain">Cereals1</title>
    <title type="title-main" language="zh" format="plain">Specifications1</title>
    <title type="title-part" language="zh" format="plain">Rice1</title>
  <docidentifier type="gb">17301&#x2014;2016</docidentifier>
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
    <stage abbreviation="IS">60</stage>
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
  <relation type="adoptedFrom">
  <description>equivalent</description>
  <bibitem>
    <docidentifier>ISO 123</docidentifier>
    <title>Rice Model document</title>
  </bibitem>
  </relation>
  <ext>
  <doctype>recommendation</doctype>
  <structuredidentifier>
    <project-number>17301</project-number>
  </structuredidentifier>
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
  </ext>
</bibdata>
</gb-standard>
    INPUT
    expect(htmlencode(metadata(gbc.info(docxml, nil)).to_s)).to be_equivalent_to htmlencode(<<~"OUTPUT")
{:accesseddate=>"2016-01-03",
:circulateddate=>"XXX",
:committee=>"Food products",
:confirmeddate=>"XXX",
:copieddate=>"XXX",
:createddate=>"2016-01-05",
:docidentifier=>"17301&#x2014;2016",
:docmaintitleen=>"Cereals and pulses&mdash;",
:docmaintitlezh=>"Cereals1&nbsp;",
:docnumber=>"17301&#x2014;2016",
:docparttitleen=>"&mdash; Rice",
:docparttitlezh=>"&nbsp;Rice1",
:docsubtitleen=>"Specifications and test methods",
:docsubtitlezh=>"Specifications1",
:doctitle=>"Cereals1&nbsp;Specifications1&nbsp;Rice1",
:doctype=>"Recommendation",
:doctype_display=>"Recommendation",
:docyear=>"2016",
:gbequivalence=>"MOD",
:gblocalcode=>"81",
:gbprefix=>"DB",
:gbscope=>"local",
:implementeddate=>"2016-01-04",
:isostandard=>"ISO 123",
:isostandardtitle=>"Rice Model document",
:issueddate=>"XXX",
:issuer=>"Ministry of Agriculture",
:labelled_implementeddate=>"2016-01-04 &#x5b9e;&#x65bd;",
:labelled_publisheddate=>"2016-01-02 &#x53d1;&#x5e03;",
:lang=>"zh",
:libraryid_ccs=>"A 01, A 02",
:libraryid_plan=>"XYZ",
:obsoleteddate=>"XXX",
:publisheddate=>"2016-01-02",
:receiveddate=>"XXX",
:sc=>"XXXX",
:script=>"Hans",
:secretariat=>"XXX",
:stage=>60,
:standard_agency=>"&#x9999;&#x6e2f;&#x7279;&#x522b;&#x884c;&#x653f;&#x533a;&#x8d28;&#x91cf;&#x6280;&#x672f;&#x68c0;&#x6d4b;&#x5c40;",
:standard_class=>"&#x9999;&#x6e2f;&#x7279;&#x522b;&#x884c;&#x653f;&#x533a;&#x5730;&#x65b9;&#x6807;&#x51c6;",
:status=>"standard",
:statusabbr=>"&#x56fd;&#x5bb6;&#x6807;&#x51c6;",
:tc=>"XXXX",
:transmitteddate=>"XXX",
:unchangeddate=>"XXX",
:unpublished=>false,
:updateddate=>"XXX",
:vote_endeddate=>"XXX",
:vote_starteddate=>"XXX",
:wg=>"XXXX"}
    OUTPUT
  end

  it "processes non-equivalent ISO doc; no part number; draft > 1; no iteration; published status; enterprise scope" do
    gbc = IsoDoc::Gb::HtmlConvert.new({})
    docxml, filename, dir = gbc.convert_init(<<~"INPUT", "test", true)
    <gb-standard xmlns="http://riboseinc.com/gbstandard">
<bibdata type="standard">
    <title type="title-intro" language="en" format="plain">Cereals and pulses</title>
    <title type="title-main" language="en" format="plain">Specifications and test methods</title>
    <title type="title-part" language="en" format="plain">Rice</title>
    <title type="title-intro" language="zh" format="plain">Cereals1</title>
    <title type="title-main" language="zh" format="plain">Specifications1</title>
    <title type="title-part" language="zh" format="plain">Rice1</title>
    <docidentifier type="gb">17301&#x2014;2016</docidentifier>
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
    <stage abbreviation="IS">60</stage>
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
  <relation type="adoptedFrom">
  <description>nonequivalent</description>
  <bibitem>
    <docidentifier>ISO 123</docidentifier>
    <title>Rice Model document</title>
  </bibitem>
  </relation>
  <ext>
  <doctype>recommendation</doctype>
  <structuredidentifier>
    <project-number>17301</project-number>
  </structuredidentifier>
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
  </ext>
</bibdata>
</gb-standard>
    INPUT
    expect(htmlencode(metadata(gbc.info(docxml, nil)).to_s)).to be_equivalent_to htmlencode(<<~"OUTPUT")
{:accesseddate=>"2016-01-03",
:circulateddate=>"XXX",
:committee=>"Food products",
:confirmeddate=>"XXX",
:copieddate=>"XXX",
:createddate=>"2016-01-05",
:docidentifier=>"17301&#x2014;2016",
:docmaintitleen=>"Cereals and pulses&mdash;",
:docmaintitlezh=>"Cereals1&nbsp;",
:docnumber=>"17301&#x2014;2016",
:docparttitleen=>"&mdash; Rice",
:docparttitlezh=>"&nbsp;Rice1",
:docsubtitleen=>"Specifications and test methods",
:docsubtitlezh=>"Specifications1",
:doctitle=>"Cereals1&nbsp;Specifications1&nbsp;Rice1",
:doctype=>"Recommendation",
:doctype_display=>"Recommendation",
:docyear=>"2016",
:gbequivalence=>"NEQ",
:gbprefix=>"ABC",
:gbscope=>"enterprise",
:implementeddate=>"2016-01-04",
:isostandard=>"ISO 123",
:isostandardtitle=>"Rice Model document",
:issueddate=>"XXX",
:issuer=>"Ministry of Agriculture",
:labelled_implementeddate=>"2016-01-04 &#x5b9e;&#x65bd;",
:labelled_publisheddate=>"2016-01-02 &#x53d1;&#x5e03;",
:lang=>"zh",
:libraryid_ccs=>"A 01, A 02",
:libraryid_plan=>"XYZ",
:obsoleteddate=>"XXX",
:publisheddate=>"2016-01-02",
:receiveddate=>"XXX",
:sc=>"XXXX",
:script=>"Hans",
:secretariat=>"XXX",
:stage=>60,
:standard_agency=>"Ministry of Agriculture",
:standard_class=>"Ministry of Agriculture&#x4f01;&#x4e1a;&#x6807;&#x51c6;",
:status=>"standard",
:statusabbr=>"&#x56fd;&#x5bb6;&#x6807;&#x51c6;",
:tc=>"XXXX",
:transmitteddate=>"XXX",
:unchangeddate=>"XXX",
:unpublished=>false,
:updateddate=>"XXX",
:vote_endeddate=>"XXX",
:vote_starteddate=>"XXX",
:wg=>"XXXX"}
    OUTPUT
  end

  it "processes non-equivalent ISO doc; no part number; draft > 1; no iteration; published status; national scope" do
    gbc = IsoDoc::Gb::HtmlConvert.new({})
    docxml, filename, dir = gbc.convert_init(<<~"INPUT", "test", true)
    <gb-standard xmlns="http://riboseinc.com/gbstandard">
<bibdata type="standard">
    <title type="title-intro" language="en" format="plain">Cereals and pulses</title>
    <title type="title-main" language="en" format="plain">Specifications and test methods</title>
    <title type="title-part" language="en" format="plain">Rice</title>
    <title type="title-intro" language="zh" format="plain">Cereals1</title>
    <title type="title-main" language="zh" format="plain">Specifications1</title>
    <title type="title-part" language="zh" format="plain">Rice1</title>
    <docidentifier type="gb">17301&#x2014;2016</docidentifier>
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
    <stage abbreviation="IS">60</stage>
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
  <relation type="adoptedFrom">
  <description>nonequivalent</description>
  <bibitem>
    <docidentifier>ISO 123</docidentifier>
    <title>Rice Model document</title>
  </bibitem>
  </relation>
  <ext>
  <doctype>recommendation</doctype>
  <structuredidentifier>
    <project-number>17301</project-number>
  </structuredidentifier>
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
  </ext>
</bibdata>
</gb-standard>
    INPUT
    expect(htmlencode(metadata(gbc.info(docxml, nil)).to_s)).to be_equivalent_to htmlencode(<<~"OUTPUT")
{:accesseddate=>"2016-01-03",
:circulateddate=>"XXX",
:committee=>"Food products",
:confirmeddate=>"XXX",
:copieddate=>"XXX",
:createddate=>"2016-01-05",
:docidentifier=>"17301&#x2014;2016",
:docmaintitleen=>"Cereals and pulses&mdash;",
:docmaintitlezh=>"Cereals1&nbsp;",
:docnumber=>"17301&#x2014;2016",
:docparttitleen=>"&mdash; Rice",
:docparttitlezh=>"&nbsp;Rice1",
:docsubtitleen=>"Specifications and test methods",
:docsubtitlezh=>"Specifications1",
:doctitle=>"Cereals1&nbsp;Specifications1&nbsp;Rice1",
:doctype=>"Recommendation",
:doctype_display=>"Recommendation",
:docyear=>"2016",
:gbequivalence=>"NEQ",
:gbprefix=>"GB",
:gbscope=>"national",
:implementeddate=>"2016-01-04",
:isostandard=>"ISO 123",
:isostandardtitle=>"Rice Model document",
:issueddate=>"XXX",
:issuer=>"Ministry of Agriculture",
:labelled_implementeddate=>"2016-01-04 &#x5b9e;&#x65bd;",
:labelled_publisheddate=>"2016-01-02 &#x53d1;&#x5e03;",
:lang=>"zh",
:libraryid_ccs=>"A 01, A 02",
:libraryid_plan=>"XYZ",
:obsoleteddate=>"XXX",
:publisheddate=>"2016-01-02",
:receiveddate=>"XXX",
:sc=>"XXXX",
:script=>"Hans",
:secretariat=>"XXX",
:stage=>60,
:standard_agency=>["&#x4e2d;&#x534e;&#x4eba;&#x6c11;&#x5171;&#x548c;&#x56fd;&#x56fd;&#x5bb6;&#x8d28;&#x91cf;&#x76d1;&#x7763;&#x68c0;&#x9a8c;&#x68c0;&#x75ab;&#x603b;&#x5c40;", "&#x4e2d;&#x56fd;&#x56fd;&#x5bb6;&#x6807;&#x51c6;&#x5316;&#x7ba1;&#x7406;&#x59d4;&#x5458;&#x4f1a;"],
:standard_class=>"&#x4e2d;&#x534e;&#x4eba;&#x6c11;&#x5171;&#x548c;&#x56fd;&#x56fd;&#x5bb6;&#x6807;&#x51c6;",
:status=>"standard",
:statusabbr=>"&#x56fd;&#x5bb6;&#x6807;&#x51c6;",
:tc=>"XXXX",
:transmitteddate=>"XXX",
:unchangeddate=>"XXX",
:unpublished=>false,
:updateddate=>"XXX",
:vote_endeddate=>"XXX",
:vote_starteddate=>"XXX",
:wg=>"XXXX"}
    OUTPUT
  end

  it "processes non-equivalent ISO doc; no part number; draft > 1; no iteration; published status; social scope" do
    gbc = IsoDoc::Gb::HtmlConvert.new({})
    docxml, filename, dir = gbc.convert_init(<<~"INPUT", "test", true)
    <gb-standard xmlns="http://riboseinc.com/gbstandard">
<bibdata type="standard">
    <title type="title-intro" language="en" format="plain">Cereals and pulses</title>
    <title type="title-main" language="en" format="plain">Specifications and test methods</title>
    <title type="title-part" language="en" format="plain">Rice</title>
    <title type="title-intro" language="zh" format="plain">Cereals1</title>
    <title type="title-main" language="zh" format="plain">Specifications1</title>
    <title type="title-part" language="zh" format="plain">Rice1</title>
    <docidentifier type="gb">17301&#x2014;2016</docidentifier>
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
    <stage abbreviation="IS">60</stage>
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
  <relation type="adoptedFrom">
  <description>nonequivalent</description>
  <bibitem>
    <docidentifier>ISO 123</docidentifier>
    <title>Rice Model document</title>
  </bibitem>
  </relation>
  <ext>
  <doctype>recommendation</doctype>
  <structuredidentifier>
    <project-number>17301</project-number>
  </structuredidentifier>
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
  </ext>
</bibdata>
</gb-standard>
    INPUT
    expect(htmlencode(metadata(gbc.info(docxml, nil)).to_s)).to be_equivalent_to htmlencode(<<~"OUTPUT")
{:accesseddate=>"2016-01-03",
:circulateddate=>"XXX",
:committee=>"Food products",
:confirmeddate=>"XXX",
:copieddate=>"XXX",
:createddate=>"2016-01-05",
:docidentifier=>"17301&#x2014;2016",
:docmaintitleen=>"Cereals and pulses&mdash;",
:docmaintitlezh=>"Cereals1&nbsp;",
:docnumber=>"17301&#x2014;2016",
:docparttitleen=>"&mdash; Rice",
:docparttitlezh=>"&nbsp;Rice1",
:docsubtitleen=>"Specifications and test methods",
:docsubtitlezh=>"Specifications1",
:doctitle=>"Cereals1&nbsp;Specifications1&nbsp;Rice1",
:doctype=>"Recommendation",
:doctype_display=>"Recommendation",
:docyear=>"2016",
:gbequivalence=>"NEQ",
:gbprefix=>"BBB",
:gbscope=>"social-group",
:implementeddate=>"2016-01-04",
:isostandard=>"ISO 123",
:isostandardtitle=>"Rice Model document",
:issueddate=>"XXX",
:issuer=>"Ministry of Agriculture",
:labelled_implementeddate=>"2016-01-04 &#x5b9e;&#x65bd;",
:labelled_publisheddate=>"2016-01-02 &#x53d1;&#x5e03;",
:lang=>"zh",
:libraryid_ccs=>"A 01, A 02",
:libraryid_plan=>"XYZ",
:obsoleteddate=>"XXX",
:publisheddate=>"2016-01-02",
:receiveddate=>"XXX",
:sc=>"XXXX",
:script=>"Hans",
:secretariat=>"XXX",
:stage=>60,
:standard_agency=>"Ministry of Agriculture",
:standard_class=>"&#x56e2;&#x4f53;&#x6807;&#x51c6;",
:status=>"standard",
:statusabbr=>"&#x56fd;&#x5bb6;&#x6807;&#x51c6;",
:tc=>"XXXX",
:transmitteddate=>"XXX",
:unchangeddate=>"XXX",
:unpublished=>false,
:updateddate=>"XXX",
:vote_endeddate=>"XXX",
:vote_starteddate=>"XXX",
:wg=>"XXXX"}
    OUTPUT
  end


end
