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
{accesseddate: "2016-01-03", bibdata: {id: "PreCD31730112016", schema_version: "v1.5.6", type: "standard", title: [{language: "en", content: "Cereals and pulses", type: "title-intro", format: "plain"}, {language: "en", content: "Specifications and test methods", type: "title-main", format: "plain"}, {language: "en", content: "Rice", type: "title-part", format: "plain"}, {language: "zh", content: "Cereals1", type: "title-intro", format: "plain"}, {language: "zh", content: "Specifications1", type: "title-main", format: "plain"}, {language: "zh", content: "Rice1", type: "title-part", format: "plain"}], docidentifier: [{content: "PreCD3 17301-1&#x2014;2016", type: "gb"}], docnumber: "17301", date: [{type: "published", at: "2016-01-02"}, {type: "accessed", at: "2016-01-03"}, {type: "implemented", at: "2016-01-04"}, {type: "created", at: "2016-01-05"}], contributor: [{role: [{type: "author"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "technical-committee"}], organization: {name: [{content: "Food products"}]}}, {role: [{type: "publisher"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "authority"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "proposer"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "issuer"}], organization: {name: [{content: "Ministry of Agriculture"}]}}], edition: {content: "2"}, version: [{content: "[\\"\\\\n  \\", \\"\\\\n  \\", \\"\\\\n\\"]"}], language: ["zh"], script: ["Hans"], status: {stage: {abbreviation: "CD", content: "30"}, substage: {content: "92"}, iteration: "3"}, copyright: [{from: "2016", owner: [{organization: {name: [{content: "Ministry of Agriculture"}]}}]}], relation: [{type: "adoptedFrom", description: {content: "identical"}, bibitem: {title: [{content: "Rice Model document"}], docidentifier: [{content: "ISO 123"}]}}], ext: {doctype: {content: "recommendation"}, ics: [{code: "1322"}], structuredidentifier: [], ccs: [{content: "A 01"}, {content: "A 02"}], plannumber: {content: "XYZ"}, gbcommittee: {type: "provisional", content: "Food products"}, gbtype: {gbscope: {content: "sector"}, gbprefix: {content: "NY"}, gbmandate: {content: "recommended"}, gbtopic: {content: "basic"}}}}, committee: "Food products", createddate: "2016-01-05", docidentifier: "PreCD3 17301-1&#x2014;2016", docmaintitleen: "Cereals and pulses&mdash;", docmaintitlezh: "Cereals1&nbsp;", docnumber: "PreCD3 17301-1&#x2014;2016", docnumeric: "17301", docparttitleen: "&mdash;Part 1:  Rice", docparttitlezh: "&nbsp;&#x7b2c;1&#x90e8;&#x5206;:Rice1", docsubtitleen: "Specifications and test methods", docsubtitlezh: "Specifications1", doctitle: "Cereals1&nbsp;Specifications1&nbsp;&#x7b2c;1&#x90e8;&#x5206;:Rice1", doctype: "Recommendation", doctype_display: "Recommendation", docyear: "2016", draft: "0.1", draftinfo: " &#xff08;&#x7a3f;0.1&#xff0c;2016-05-01&#xff09;", edition: "2", gbequivalence: "IDT", gbprefix: "NY", gbscope: "sector", ics: "1322", implementeddate: "2016-01-04", isostandard: "ISO 123", isostandardtitle: "Rice Model document", issuer: "Ministry of Agriculture", labelled_implementeddate: "2016-01-04 &#x5b9e;&#x65bd;", labelled_publisheddate: "2016-01-02 &#x53d1;&#x5e03;", lang: "zh", libraryid_ccs: "A 01, A 02", libraryid_plan: "XYZ", publisheddate: "2016-01-02", revdate: "2016-05-01", revdate_monthyear: "&#x4e94;&#x6708;2016", script: "Hans", stage: 30, stageabbr: "CD", standard_agency: "&#x519c;&#x4e1a;&#x90e8;", standard_class: "&#x4e2d;&#x534e;&#x4eba;&#x6c11;&#x5171;&#x548c;&#x56fd;&#x519c;&#x4e1a;&#x884c;&#x4e1a;&#x6807;&#x51c6;", status: "committee-draft", statusabbr: "Pre&#x4e09;&#x6b21;&#x6807;&#x51c6;&#x8349;&#x6848;&#x5f81;&#x6c42;&#x610f;&#x89c1;&#x7a3f;", unpublished: true}
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
{accesseddate: "2016-01-03", bibdata: {id: "PreCD31730112016", schema_version: "v1.5.6", type: "standard", title: [{language: "en", content: "Cereals and pulses", type: "title-intro", format: "plain"}, {language: "en", content: "Specifications and test methods", type: "title-main", format: "plain"}, {language: "en", content: "Rice", type: "title-part", format: "plain"}, {language: "zh", content: "Cereals1", type: "title-intro", format: "plain"}, {language: "zh", content: "Specifications1", type: "title-main", format: "plain"}, {language: "zh", content: "Rice1", type: "title-part", format: "plain"}], docidentifier: [{content: "PreCD3 17301-1&#x2014;2016", type: "gb"}], date: [{type: "published", at: "2016-01-02"}, {type: "accessed", at: "2016-01-03"}, {type: "implemented", at: "2016-01-04"}, {type: "created", at: "2016-01-05"}], contributor: [{role: [{type: "author"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "technical-committee"}], organization: {name: [{content: "Food products"}]}}, {role: [{type: "publisher"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "authority"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "proposer"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "issuer"}], organization: {name: [{content: "Ministry of Agriculture"}]}}], edition: {content: "2"}, version: [{content: "[\\"\\\\n  \\", \\"\\\\n  \\", \\"\\\\n\\"]"}], language: ["en"], script: ["Latn"], status: {stage: {abbreviation: "IS", content: "60"}, substage: {content: "92"}, iteration: "3"}, copyright: [{from: "2016", owner: [{organization: {name: [{content: "Ministry of Agriculture"}]}}]}], relation: [{type: "adoptedFrom", description: {content: "identical"}, bibitem: {title: [{content: "Rice Model document"}], docidentifier: [{content: "ISO 123"}]}}], ext: {doctype: {content: "recommendation"}, structuredidentifier: [], ccs: [{content: "A 01"}, {content: "A 02"}], plannumber: {content: "XYZ"}, gbcommittee: {type: "provisional", content: "Food products"}, gbtype: {gbscope: {content: "sector"}, gbprefix: {content: "NY"}, gbmandate: {content: "recommended"}, gbtopic: {content: "basic"}}}}, committee: "Food products", createddate: "2016-01-05", docidentifier: "PreCD3 17301-1&#x2014;2016", docmaintitleen: "Cereals and pulses&mdash;", docmaintitlezh: "Cereals1&nbsp;", docnumber: "PreCD3 17301-1&#x2014;2016", docparttitleen: "&mdash;Part 1:  Rice", docparttitlezh: "&nbsp;&#x7b2c;1&#x90e8;&#x5206;:Rice1", docsubtitleen: "Specifications and test methods", docsubtitlezh: "Specifications1", doctitle: "Cereals and pulses&mdash;Specifications and test methods&mdash;Part 1:  Rice", doctype: "Recommendation", doctype_display: "Recommendation", docyear: "2016", draft: "0.1", draftinfo: " (draft 0.1, 2016-05-01)", edition: "2", gbequivalence: "IDT", gbprefix: "NY", gbscope: "sector", implementeddate: "2016-01-04", isostandard: "ISO 123", isostandardtitle: "Rice Model document", issuer: "Ministry of Agriculture", labelled_implementeddate: "Implementation Date: 2016-01-04", labelled_publisheddate: "Issuance Date: 2016-01-02", lang: "en", libraryid_ccs: "A 01, A 02", libraryid_plan: "XYZ", publisheddate: "2016-01-02", revdate: "2016-05-01", revdate_monthyear: "May 2016", script: "Latn", stage: 60, standard_agency: "Ministry of Agriculture", standard_class: "People's Republic of China  Agriculture  Industry Standard", status: "standard", statusabbr: "PreIS", unpublished: false}
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
{accesseddate: "2016-01-03", bibdata: {id: "PreCD31730112016", schema_version: "v1.5.6", type: "standard", title: [{language: "en", content: "Cereals and pulses", type: "title-intro", format: "plain"}, {language: "en", content: "Specifications and test methods", type: "title-main", format: "plain"}, {language: "en", content: "Rice", type: "title-part", format: "plain"}, {language: "zh", content: "Cereals1", type: "title-intro", format: "plain"}, {language: "zh", content: "Specifications1", type: "title-main", format: "plain"}, {language: "zh", content: "Rice1", type: "title-part", format: "plain"}], docidentifier: [{content: "PreCD3 17301-1&#x2014;2016", type: "gb"}], date: [{type: "published", at: "2016-01-02"}, {type: "accessed", at: "2016-01-03"}, {type: "implemented", at: "2016-01-04"}, {type: "created", at: "2016-01-05"}], contributor: [{role: [{type: "author"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "technical-committee"}], organization: {name: [{content: "Food products"}]}}, {role: [{type: "publisher"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "authority"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "proposer"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "issuer"}], organization: {name: [{content: "Ministry of Agriculture"}]}}], version: [{content: "[\\"\\\\n  \\", \\"\\\\n  \\", \\"\\\\n\\"]"}], language: ["tlh"], script: ["Hans"], status: {stage: {abbreviation: "CD", content: "30"}, substage: {content: "92"}, iteration: "3"}, copyright: [{from: "2016", owner: [{organization: {name: [{content: "Ministry of Agriculture"}]}}]}], relation: [{type: "adoptedFrom", description: {content: "identical"}, bibitem: {title: [{content: "Rice Model document"}], docidentifier: [{content: "ISO 123"}]}}], ext: {doctype: {content: "recommendation"}, structuredidentifier: [], ccs: [{content: "A 01"}, {content: "A 02"}], plannumber: {content: "XYZ"}, gbcommittee: {type: "provisional", content: "Food products"}, gbtype: {gbscope: {content: "sector"}, gbprefix: {content: "NY"}, gbmandate: {content: "recommended"}, gbtopic: {content: "basic"}}}}, committee: "Food products", createddate: "2016-01-05", docidentifier: "PreCD3 17301-1&#x2014;2016", docmaintitleen: "Cereals and pulses&mdash;", docmaintitlezh: "Cereals1&nbsp;", docnumber: "PreCD3 17301-1&#x2014;2016", docparttitleen: "&mdash;Part 1:  Rice", docparttitlezh: "&nbsp;&#x7b2c;1&#x90e8;&#x5206;:Rice1", docsubtitleen: "Specifications and test methods", docsubtitlezh: "Specifications1", doctitle: "Cereals1&nbsp;Specifications1&nbsp;&#x7b2c;1&#x90e8;&#x5206;:Rice1", doctype: "Recommendation", doctype_display: "Recommendation", docyear: "2016", draft: "0.1", draftinfo: " (draft 0.1, 2016-05-01)", gbequivalence: "IDT", gbprefix: "NY", gbscope: "sector", implementeddate: "2016-01-04", isostandard: "ISO 123", isostandardtitle: "Rice Model document", issuer: "Ministry of Agriculture", labelled_implementeddate: "2016-01-04 &#x5b9e;&#x65bd;", labelled_publisheddate: "2016-01-02 &#x53d1;&#x5e03;", lang: "zh", libraryid_ccs: "A 01, A 02", libraryid_plan: "XYZ", publisheddate: "2016-01-02", revdate: "2016-05-01", revdate_monthyear: "&#x4e94;&#x6708;2016", script: "Hans", stage: 30, stageabbr: "CD", standard_agency: "&#x519c;&#x4e1a;&#x90e8;", standard_class: "&#x4e2d;&#x534e;&#x4eba;&#x6c11;&#x5171;&#x548c;&#x56fd;&#x519c;&#x4e1a;&#x884c;&#x4e1a;&#x6807;&#x51c6;", status: "committee-draft", statusabbr: "Pre&#x4e09;&#x6b21;&#x6807;&#x51c6;&#x8349;&#x6848;&#x5f81;&#x6c42;&#x610f;&#x89c1;&#x7a3f;", unpublished: true}
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
{accesseddate: "2016-01-03", bibdata: {id: "173012016", schema_version: "v1.5.6", type: "standard", title: [{language: "en", content: "Cereals and pulses", type: "title-intro", format: "plain"}, {language: "en", content: "Specifications and test methods", type: "title-main", format: "plain"}, {language: "en", content: "Rice", type: "title-part", format: "plain"}, {language: "zh", content: "Cereals1", type: "title-intro", format: "plain"}, {language: "zh", content: "Specifications1", type: "title-main", format: "plain"}, {language: "zh", content: "Rice1", type: "title-part", format: "plain"}], docidentifier: [{content: "17301&#x2014;2016", type: "gb"}], date: [{type: "published", at: "2016-01-02"}, {type: "accessed", at: "2016-01-03"}, {type: "implemented", at: "2016-01-04"}, {type: "created", at: "2016-01-05"}], contributor: [{role: [{type: "author"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "technical-committee"}], organization: {name: [{content: "Food products"}]}}, {role: [{type: "publisher"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "authority"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "proposer"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "issuer"}], organization: {name: [{content: "Ministry of Agriculture"}]}}], language: ["zh"], script: ["Hans"], status: {stage: {abbreviation: "IS", content: "60"}, substage: {content: "92"}}, copyright: [{from: "2016", owner: [{organization: {name: [{content: "Ministry of Agriculture"}]}}]}], relation: [{type: "adoptedFrom", description: {content: "equivalent"}, bibitem: {title: [{content: "Rice Model document"}], docidentifier: [{content: "ISO 123"}]}}], ext: {doctype: {content: "recommendation"}, structuredidentifier: [], ccs: [{content: "A 01"}, {content: "A 02"}], plannumber: {content: "XYZ"}, gbcommittee: {type: "provisional", content: "Food products"}, gbtype: {gbscope: {content: "local"}, gbprefix: {content: "81"}, gbmandate: {content: "recommended"}, gbtopic: {content: "basic"}}}}, committee: "Food products", createddate: "2016-01-05", docidentifier: "17301&#x2014;2016", docmaintitleen: "Cereals and pulses&mdash;", docmaintitlezh: "Cereals1&nbsp;", docnumber: "17301&#x2014;2016", docparttitleen: "&mdash; Rice", docparttitlezh: "&nbsp;Rice1", docsubtitleen: "Specifications and test methods", docsubtitlezh: "Specifications1", doctitle: "Cereals1&nbsp;Specifications1&nbsp;Rice1", doctype: "Recommendation", doctype_display: "Recommendation", docyear: "2016", gbequivalence: "MOD", gblocalcode: "81", gbprefix: "DB", gbscope: "local", implementeddate: "2016-01-04", isostandard: "ISO 123", isostandardtitle: "Rice Model document", issuer: "Ministry of Agriculture", labelled_implementeddate: "2016-01-04 &#x5b9e;&#x65bd;", labelled_publisheddate: "2016-01-02 &#x53d1;&#x5e03;", lang: "zh", libraryid_ccs: "A 01, A 02", libraryid_plan: "XYZ", publisheddate: "2016-01-02", script: "Hans", stage: 60, standard_agency: "&#x9999;&#x6e2f;&#x7279;&#x522b;&#x884c;&#x653f;&#x533a;&#x8d28;&#x91cf;&#x6280;&#x672f;&#x68c0;&#x6d4b;&#x5c40;", standard_class: "&#x9999;&#x6e2f;&#x7279;&#x522b;&#x884c;&#x653f;&#x533a;&#x5730;&#x65b9;&#x6807;&#x51c6;", status: "standard", statusabbr: "&#x56fd;&#x5bb6;&#x6807;&#x51c6;", unpublished: false}
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
{accesseddate: "2016-01-03", bibdata: {id: "173012016", schema_version: "v1.5.6", type: "standard", title: [{language: "en", content: "Cereals and pulses", type: "title-intro", format: "plain"}, {language: "en", content: "Specifications and test methods", type: "title-main", format: "plain"}, {language: "en", content: "Rice", type: "title-part", format: "plain"}, {language: "zh", content: "Cereals1", type: "title-intro", format: "plain"}, {language: "zh", content: "Specifications1", type: "title-main", format: "plain"}, {language: "zh", content: "Rice1", type: "title-part", format: "plain"}], docidentifier: [{content: "17301&#x2014;2016", type: "gb"}], date: [{type: "published", at: "2016-01-02"}, {type: "accessed", at: "2016-01-03"}, {type: "implemented", at: "2016-01-04"}, {type: "created", at: "2016-01-05"}], contributor: [{role: [{type: "author"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "technical-committee"}], organization: {name: [{content: "Food products"}]}}, {role: [{type: "publisher"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "authority"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "proposer"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "issuer"}], organization: {name: [{content: "Ministry of Agriculture"}]}}], language: ["zh"], script: ["Hans"], status: {stage: {abbreviation: "IS", content: "60"}, substage: {content: "92"}}, copyright: [{from: "2016", owner: [{organization: {name: [{content: "Ministry of Agriculture"}]}}]}], relation: [{type: "adoptedFrom", description: {content: "nonequivalent"}, bibitem: {title: [{content: "Rice Model document"}], docidentifier: [{content: "ISO 123"}]}}], ext: {doctype: {content: "recommendation"}, structuredidentifier: [], ccs: [{content: "A 01"}, {content: "A 02"}], plannumber: {content: "XYZ"}, gbcommittee: {type: "provisional", content: "Food products"}, gbtype: {gbscope: {content: "enterprise"}, gbprefix: {content: "ABC"}, gbmandate: {content: "recommended"}, gbtopic: {content: "basic"}}}}, committee: "Food products", createddate: "2016-01-05", docidentifier: "17301&#x2014;2016", docmaintitleen: "Cereals and pulses&mdash;", docmaintitlezh: "Cereals1&nbsp;", docnumber: "17301&#x2014;2016", docparttitleen: "&mdash; Rice", docparttitlezh: "&nbsp;Rice1", docsubtitleen: "Specifications and test methods", docsubtitlezh: "Specifications1", doctitle: "Cereals1&nbsp;Specifications1&nbsp;Rice1", doctype: "Recommendation", doctype_display: "Recommendation", docyear: "2016", gbequivalence: "NEQ", gbprefix: "ABC", gbscope: "enterprise", implementeddate: "2016-01-04", isostandard: "ISO 123", isostandardtitle: "Rice Model document", issuer: "Ministry of Agriculture", labelled_implementeddate: "2016-01-04 &#x5b9e;&#x65bd;", labelled_publisheddate: "2016-01-02 &#x53d1;&#x5e03;", lang: "zh", libraryid_ccs: "A 01, A 02", libraryid_plan: "XYZ", publisheddate: "2016-01-02", script: "Hans", stage: 60, standard_agency: "Ministry of Agriculture", standard_class: "Ministry of Agriculture&#x4f01;&#x4e1a;&#x6807;&#x51c6;", status: "standard", statusabbr: "&#x56fd;&#x5bb6;&#x6807;&#x51c6;", unpublished: false}
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
{accesseddate: "2016-01-03", bibdata: {id: "173012016", schema_version: "v1.5.6", type: "standard", title: [{language: "en", content: "Cereals and pulses", type: "title-intro", format: "plain"}, {language: "en", content: "Specifications and test methods", type: "title-main", format: "plain"}, {language: "en", content: "Rice", type: "title-part", format: "plain"}, {language: "zh", content: "Cereals1", type: "title-intro", format: "plain"}, {language: "zh", content: "Specifications1", type: "title-main", format: "plain"}, {language: "zh", content: "Rice1", type: "title-part", format: "plain"}], docidentifier: [{content: "17301&#x2014;2016", type: "gb"}], date: [{type: "published", at: "2016-01-02"}, {type: "accessed", at: "2016-01-03"}, {type: "implemented", at: "2016-01-04"}, {type: "created", at: "2016-01-05"}], contributor: [{role: [{type: "author"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "technical-committee"}], organization: {name: [{content: "Food products"}]}}, {role: [{type: "publisher"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "authority"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "proposer"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "issuer"}], organization: {name: [{content: "Ministry of Agriculture"}]}}], language: ["zh"], script: ["Hans"], status: {stage: {abbreviation: "IS", content: "60"}, substage: {content: "92"}}, copyright: [{from: "2016", owner: [{organization: {name: [{content: "Ministry of Agriculture"}]}}]}], relation: [{type: "adoptedFrom", description: {content: "nonequivalent"}, bibitem: {title: [{content: "Rice Model document"}], docidentifier: [{content: "ISO 123"}]}}], ext: {doctype: {content: "recommendation"}, structuredidentifier: [], ccs: [{content: "A 01"}, {content: "A 02"}], plannumber: {content: "XYZ"}, gbcommittee: {type: "provisional", content: "Food products"}, gbtype: {gbscope: {content: "national"}, gbprefix: {content: "GB"}, gbmandate: {content: "recommended"}, gbtopic: {content: "basic"}}}}, committee: "Food products", createddate: "2016-01-05", docidentifier: "17301&#x2014;2016", docmaintitleen: "Cereals and pulses&mdash;", docmaintitlezh: "Cereals1&nbsp;", docnumber: "17301&#x2014;2016", docparttitleen: "&mdash; Rice", docparttitlezh: "&nbsp;Rice1", docsubtitleen: "Specifications and test methods", docsubtitlezh: "Specifications1", doctitle: "Cereals1&nbsp;Specifications1&nbsp;Rice1", doctype: "Recommendation", doctype_display: "Recommendation", docyear: "2016", gbequivalence: "NEQ", gbprefix: "GB", gbscope: "national", implementeddate: "2016-01-04", isostandard: "ISO 123", isostandardtitle: "Rice Model document", issuer: "Ministry of Agriculture", labelled_implementeddate: "2016-01-04 &#x5b9e;&#x65bd;", labelled_publisheddate: "2016-01-02 &#x53d1;&#x5e03;", lang: "zh", libraryid_ccs: "A 01, A 02", libraryid_plan: "XYZ", publisheddate: "2016-01-02", script: "Hans", stage: 60, standard_agency: ["&#x4e2d;&#x534e;&#x4eba;&#x6c11;&#x5171;&#x548c;&#x56fd;&#x56fd;&#x5bb6;&#x8d28;&#x91cf;&#x76d1;&#x7763;&#x68c0;&#x9a8c;&#x68c0;&#x75ab;&#x603b;&#x5c40;", "&#x4e2d;&#x56fd;&#x56fd;&#x5bb6;&#x6807;&#x51c6;&#x5316;&#x7ba1;&#x7406;&#x59d4;&#x5458;&#x4f1a;"], standard_class: "&#x4e2d;&#x534e;&#x4eba;&#x6c11;&#x5171;&#x548c;&#x56fd;&#x56fd;&#x5bb6;&#x6807;&#x51c6;", status: "standard", statusabbr: "&#x56fd;&#x5bb6;&#x6807;&#x51c6;", unpublished: false}
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
{accesseddate: "2016-01-03", bibdata: {id: "173012016", schema_version: "v1.5.6", type: "standard", title: [{language: "en", content: "Cereals and pulses", type: "title-intro", format: "plain"}, {language: "en", content: "Specifications and test methods", type: "title-main", format: "plain"}, {language: "en", content: "Rice", type: "title-part", format: "plain"}, {language: "zh", content: "Cereals1", type: "title-intro", format: "plain"}, {language: "zh", content: "Specifications1", type: "title-main", format: "plain"}, {language: "zh", content: "Rice1", type: "title-part", format: "plain"}], docidentifier: [{content: "17301&#x2014;2016", type: "gb"}], date: [{type: "published", at: "2016-01-02"}, {type: "accessed", at: "2016-01-03"}, {type: "implemented", at: "2016-01-04"}, {type: "created", at: "2016-01-05"}], contributor: [{role: [{type: "author"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "technical-committee"}], organization: {name: [{content: "Food products"}]}}, {role: [{type: "publisher"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "authority"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "proposer"}], organization: {name: [{content: "GB"}]}}, {role: [{type: "issuer"}], organization: {name: [{content: "Ministry of Agriculture"}]}}], language: ["zh"], script: ["Hans"], status: {stage: {abbreviation: "IS", content: "60"}, substage: {content: "92"}}, copyright: [{from: "2016", owner: [{organization: {name: [{content: "Ministry of Agriculture"}]}}]}], relation: [{type: "adoptedFrom", description: {content: "nonequivalent"}, bibitem: {title: [{content: "Rice Model document"}], docidentifier: [{content: "ISO 123"}]}}], ext: {doctype: {content: "recommendation"}, structuredidentifier: [], ccs: [{content: "A 01"}, {content: "A 02"}], plannumber: {content: "XYZ"}, gbcommittee: {type: "provisional", content: "Food products"}, gbtype: {gbscope: {content: "social-group"}, gbprefix: {content: "BBB"}, gbmandate: {content: "recommended"}, gbtopic: {content: "basic"}}}}, committee: "Food products", createddate: "2016-01-05", docidentifier: "17301&#x2014;2016", docmaintitleen: "Cereals and pulses&mdash;", docmaintitlezh: "Cereals1&nbsp;", docnumber: "17301&#x2014;2016", docparttitleen: "&mdash; Rice", docparttitlezh: "&nbsp;Rice1", docsubtitleen: "Specifications and test methods", docsubtitlezh: "Specifications1", doctitle: "Cereals1&nbsp;Specifications1&nbsp;Rice1", doctype: "Recommendation", doctype_display: "Recommendation", docyear: "2016", gbequivalence: "NEQ", gbprefix: "BBB", gbscope: "social-group", implementeddate: "2016-01-04", isostandard: "ISO 123", isostandardtitle: "Rice Model document", issuer: "Ministry of Agriculture", labelled_implementeddate: "2016-01-04 &#x5b9e;&#x65bd;", labelled_publisheddate: "2016-01-02 &#x53d1;&#x5e03;", lang: "zh", libraryid_ccs: "A 01, A 02", libraryid_plan: "XYZ", publisheddate: "2016-01-02", script: "Hans", stage: 60, standard_agency: "Ministry of Agriculture", standard_class: "&#x56e2;&#x4f53;&#x6807;&#x51c6;", status: "standard", statusabbr: "&#x56fd;&#x5bb6;&#x6807;&#x51c6;", unpublished: false}
    OUTPUT
  end


end
