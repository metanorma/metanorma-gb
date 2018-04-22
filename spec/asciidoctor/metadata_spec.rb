# encoding: UTF-8
require "spec_helper"
require "nokogiri"
require "htmlentities"

RSpec.describe Asciidoctor::Gb::GbConvert do
  it "processes IsoXML metadata in Chinese" do
    gbc = Asciidoctor::Gb::GbConvert.new({})
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
  <docidentifier>
    <project-number part="1">17301</project-number>
  </docidentifier>
  <date type="published">
    <from>2016-01-02</from>
  </date>
  <date type="accessed">
    <from>2016-01-03</from>
  </date>
  <date type="implemented">
    <from>2016-01-04</from>
  </date>
  <date type="created">
    <from>2016-01-05</from>
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
  <ics>1322</ics>
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
           {:accesseddate=>"2016-01-03", :committee=>"Food products", :confirmeddate=>"XXX", :createddate=>"2016-01-05", :docidentifier=>"NY/T&#x2002;PreCD3 17301-1&mdash;2016", :docmaintitleen=>"Cereals and pulses&mdash;", :docmaintitlezh=>"Cereals1&nbsp;", :docnumber=>"PreCD3 17301-1", :docparttitleen=>"&mdash;Part 1:  Rice", :docparttitlezh=>"&nbsp;\\u7B2C1\\u90E8\\u5206:Rice1", :docsubtitleen=>"Specifications and test methods", :docsubtitlezh=>"Specifications1", :doctitle=>"Cereals1&nbsp;Specifications1&nbsp;\\u7B2C1\\u90E8\\u5206:Rice1", :doctype=>"Recommendation", :docyear=>"2016", :draft=>"0.1", :draftinfo=>"\\uFF08\\u7A3F0.1\\u30012016-05-01\\uFF09", :editorialgroup=>[], :gbequivalence=>"IDT", :gbprefix=>"NY", :gbscope=>"sector", :implementeddate=>"2016-01-04", :isostandard=>"ISO 123", :isostandardtitle=>"Rice Model document", :issueddate=>"XXX", :issuer=>"Ministry of Agriculture", :labelled_implementeddate=>"2016-01-04 \\u5B9E\\u65BD", :labelled_publisheddate=>"2016-01-02 \\u53D1\\u5E03", :libraryid_ccs=>"A 01, A 02", :libraryid_ics=>"1322", :libraryid_plan=>"XYZ", :obsoleteddate=>"XXX", :obsoletes=>nil, :obsoletes_part=>nil, :publisheddate=>"2016-01-02", :revdate=>"2016-05-01", :sc=>"XXXX", :secretariat=>"XXXX", :stage=>30, :stageabbr=>"Pre\\u4E09\\u6B21\\u6807\\u51C6\\u8349\\u6848\\u5F81\\u6C42\\u610F\\u89C1\\u7A3F", :standard_agency=>"\\u519C\\u4E1A\\u90E8", :standard_class=>"\\u4E2D\\u534E\\u4EBA\\u6C11\\u5171\\u548C\\u56FD\\u519C\\u4E1A\\u884C\\u4E1A\\u6807\\u51C6", :tc=>"XXXX", :updateddate=>"XXX", :wg=>"XXXX"}
    OUTPUT
  end

  it "processes IsoXML metadata in English" do
    gbc = Asciidoctor::Gb::GbConvert.new({})
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
  <docidentifier>
    <project-number part="1">17301</project-number>
  </docidentifier>
  <date type="published">
    <from>2016-01-02</from>
  </date>
  <date type="accessed">
    <from>2016-01-03</from>
  </date>
  <date type="implemented">
    <from>2016-01-04</from>
  </date>
  <date type="created">
    <from>2016-01-05</from>
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
  <language>en</language>
  <script>Latn</script>
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
  <ics>1322</ics>
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
           {:accesseddate=>"2016-01-03", :committee=>"Food products", :confirmeddate=>"XXX", :createddate=>"2016-01-05", :docidentifier=>"NY/T&#x2002;PreCD3 17301-1&mdash;2016", :docmaintitleen=>"Cereals and pulses&mdash;", :docmaintitlezh=>"Cereals1&nbsp;", :docnumber=>"PreCD3 17301-1", :docparttitleen=>"&mdash;Part 1:  Rice", :docparttitlezh=>"&nbsp;\\u7B2C1\\u90E8\\u5206:Rice1", :docsubtitleen=>"Specifications and test methods", :docsubtitlezh=>"Specifications1", :doctitle=>"Cereals and pulses&mdash;Specifications and test methods&mdash;Part 1:  Rice", :doctype=>"Recommendation", :docyear=>"2016", :draft=>"0.1", :draftinfo=>" (draft 0.1, 2016-05-01)", :editorialgroup=>[], :gbequivalence=>"IDT", :gbprefix=>"NY", :gbscope=>"sector", :implementeddate=>"2016-01-04", :isostandard=>"ISO 123", :isostandardtitle=>"Rice Model document", :issueddate=>"XXX", :issuer=>"Ministry of Agriculture", :labelled_implementeddate=>"Implementation Date: 2016-01-04", :labelled_publisheddate=>"Issuance Date: 2016-01-02", :libraryid_ccs=>"A 01, A 02", :libraryid_ics=>"1322", :libraryid_plan=>"XYZ", :obsoleteddate=>"XXX", :obsoletes=>nil, :obsoletes_part=>nil, :publisheddate=>"2016-01-02", :revdate=>"2016-05-01", :sc=>"XXXX", :secretariat=>"XXXX", :stage=>30, :stageabbr=>"PreCD3", :standard_agency=>"Ministry of Agriculture", :standard_class=>"People&#x27;s Republic of China Agriculture Industry Standard", :tc=>"XXXX", :updateddate=>"XXX", :wg=>"XXXX"}
    OUTPUT

  end

  it "processes equivalent ISO doc; no part number; draft > 1; no iteration; published status; local scope" do
    gbc = Asciidoctor::Gb::GbConvert.new({})
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
  <docidentifier>
    <project-number>17301</project-number>
  </docidentifier>
  <date type="published">
    <from>2016-01-02</from>
  </date>
  <date type="accessed">
    <from>2016-01-03</from>
  </date>
  <date type="implemented">
    <from>2016-01-04</from>
  </date>
  <date type="created">
    <from>2016-01-05</from>
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
  <ics>1322</ics>
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
</bibdata><version>
  <edition>2</edition>
  <draft>1</draft>
  <revision-date>2016-05-01</revision-date>
</version>
</gb-standard>
INPUT
    expect(htmlencode(Hash[gbc.info(docxml, nil).sort].to_s)).to be_equivalent_to <<~"OUTPUT"
           {:accesseddate=>"2016-01-03", :committee=>"Food products", :confirmeddate=>"XXX", :createddate=>"2016-01-05", :docidentifier=>"DB81/T 17301&mdash;2016", :docmaintitleen=>"Cereals and pulses&mdash;", :docmaintitlezh=>"Cereals1&nbsp;", :docnumber=>"17301", :docparttitleen=>"&mdash; Rice", :docparttitlezh=>"&nbsp;Rice1", :docsubtitleen=>"Specifications and test methods", :docsubtitlezh=>"Specifications1", :doctitle=>"Cereals1&nbsp;Specifications1&nbsp;Rice1", :doctype=>"Recommendation", :docyear=>"2016", :draft=>"1", :draftinfo=>"\\uFF08\\u7A3F1\\u30012016-05-01\\uFF09", :editorialgroup=>[], :gbequivalence=>"MOD", :gbprefix=>"DB", :gbscope=>"local", :implementeddate=>"2016-01-04", :isostandard=>"ISO 123", :isostandardtitle=>"Rice Model document", :issueddate=>"XXX", :issuer=>"Ministry of Agriculture", :labelled_implementeddate=>"2016-01-04 \\u5B9E\\u65BD", :labelled_publisheddate=>"2016-01-02 \\u53D1\\u5E03", :libraryid_ccs=>"A 01, A 02", :libraryid_ics=>"1322", :libraryid_plan=>"XYZ", :obsoleteddate=>"XXX", :obsoletes=>nil, :obsoletes_part=>nil, :publisheddate=>"2016-01-02", :revdate=>"2016-05-01", :sc=>"XXXX", :secretariat=>"XXXX", :stage=>60, :stageabbr=>"\\u56FD\\u5BB6\\u6807\\u51C6", :standard_agency=>"\\u9999\\u6E2F\\u7279\\u522B\\u884C\\u653F\\u533A\\u8D28\\u91CF\\u6280\\u672F\\u68C0\\u6D4B\\u5C40", :standard_class=>"\\u9999\\u6E2F\\u7279\\u522B\\u884C\\u653F\\u533A\\u5730\\u65B9\\u6807\\u51C6", :tc=>"XXXX", :updateddate=>"XXX", :wg=>"XXXX"}
    OUTPUT
end

    it "processes non-equivalent ISO doc; no part number; draft > 1; no iteration; published status; enterprise scope" do
    gbc = Asciidoctor::Gb::GbConvert.new({})
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
  <docidentifier>
    <project-number>17301</project-number>
  </docidentifier>
  <date type="published">
    <from>2016-01-02</from>
  </date>
  <date type="accessed">
    <from>2016-01-03</from>
  </date>
  <date type="implemented">
    <from>2016-01-04</from>
  </date>
  <date type="created">
    <from>2016-01-05</from>
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
  <ics>1322</ics>
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
</bibdata><version>
  <edition>2</edition>
  <draft>1</draft>
  <revision-date>2016-05-01</revision-date>
</version>
</gb-standard>
INPUT
    expect(htmlencode(Hash[gbc.info(docxml, nil).sort].to_s)).to be_equivalent_to <<~"OUTPUT"
           {:accesseddate=>"2016-01-03", :committee=>"Food products", :confirmeddate=>"XXX", :createddate=>"2016-01-05", :docidentifier=>"Q/T/ABC 17301&mdash;2016", :docmaintitleen=>"Cereals and pulses&mdash;", :docmaintitlezh=>"Cereals1&nbsp;", :docnumber=>"17301", :docparttitleen=>"&mdash; Rice", :docparttitlezh=>"&nbsp;Rice1", :docsubtitleen=>"Specifications and test methods", :docsubtitlezh=>"Specifications1", :doctitle=>"Cereals1&nbsp;Specifications1&nbsp;Rice1", :doctype=>"Recommendation", :docyear=>"2016", :draft=>"1", :draftinfo=>"\\uFF08\\u7A3F1\\u30012016-05-01\\uFF09", :editorialgroup=>[], :gbequivalence=>"NEQ", :gbprefix=>"ABC", :gbscope=>"enterprise", :implementeddate=>"2016-01-04", :isostandard=>"ISO 123", :isostandardtitle=>"Rice Model document", :issueddate=>"XXX", :issuer=>"Ministry of Agriculture", :labelled_implementeddate=>"2016-01-04 \\u5B9E\\u65BD", :labelled_publisheddate=>"2016-01-02 \\u53D1\\u5E03", :libraryid_ccs=>"A 01, A 02", :libraryid_ics=>"1322", :libraryid_plan=>"XYZ", :obsoleteddate=>"XXX", :obsoletes=>nil, :obsoletes_part=>nil, :publisheddate=>"2016-01-02", :revdate=>"2016-05-01", :sc=>"XXXX", :secretariat=>"XXXX", :stage=>60, :stageabbr=>"\\u56FD\\u5BB6\\u6807\\u51C6", :standard_agency=>"Ministry of Agriculture", :standard_class=>"Ministry of Agriculture\\u4F01\\u4E1A\\u6807\\u51C6", :tc=>"XXXX", :updateddate=>"XXX", :wg=>"XXXX"}
    OUTPUT
end

        it "processes non-equivalent ISO doc; no part number; draft > 1; no iteration; published status; national scope" do
    gbc = Asciidoctor::Gb::GbConvert.new({})
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
  <docidentifier>
    <project-number>17301</project-number>
  </docidentifier>
  <date type="published">
    <from>2016-01-02</from>
  </date>
  <date type="accessed">
    <from>2016-01-03</from>
  </date>
  <date type="implemented">
    <from>2016-01-04</from>
  </date>
  <date type="created">
    <from>2016-01-05</from>
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
  <ics>1322</ics>
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
</bibdata><version>
  <edition>2</edition>
  <draft>1</draft>
  <revision-date>2016-05-01</revision-date>
</version>
</gb-standard>
INPUT
    expect(htmlencode(Hash[gbc.info(docxml, nil).sort].to_s)).to be_equivalent_to <<~"OUTPUT"
           {:accesseddate=>"2016-01-03", :committee=>"Food products", :confirmeddate=>"XXX", :createddate=>"2016-01-05", :docidentifier=>"GB/T&#x2002;17301&mdash;2016", :docmaintitleen=>"Cereals and pulses&mdash;", :docmaintitlezh=>"Cereals1&nbsp;", :docnumber=>"17301", :docparttitleen=>"&mdash; Rice", :docparttitlezh=>"&nbsp;Rice1", :docsubtitleen=>"Specifications and test methods", :docsubtitlezh=>"Specifications1", :doctitle=>"Cereals1&nbsp;Specifications1&nbsp;Rice1", :doctype=>"Recommendation", :docyear=>"2016", :draft=>"1", :draftinfo=>"\\uFF08\\u7A3F1\\u30012016-05-01\\uFF09", :editorialgroup=>[], :gbequivalence=>"NEQ", :gbprefix=>"GB", :gbscope=>"national", :implementeddate=>"2016-01-04", :isostandard=>"ISO 123", :isostandardtitle=>"Rice Model document", :issueddate=>"XXX", :issuer=>"Ministry of Agriculture", :labelled_implementeddate=>"2016-01-04 \\u5B9E\\u65BD", :labelled_publisheddate=>"2016-01-02 \\u53D1\\u5E03", :libraryid_ccs=>"A 01, A 02", :libraryid_ics=>"1322", :libraryid_plan=>"XYZ", :obsoleteddate=>"XXX", :obsoletes=>nil, :obsoletes_part=>nil, :publisheddate=>"2016-01-02", :revdate=>"2016-05-01", :sc=>"XXXX", :secretariat=>"XXXX", :stage=>60, :stageabbr=>"\\u56FD\\u5BB6\\u6807\\u51C6", :standard_agency=>["\\u4E2D\\u534E\\u4EBA\\u6C11\\u5171\\u548C\\u56FD\\u56FD\\u5BB6\\u8D28\\u91CF\\u76D1\\u7763\\u68C0\\u9A8C\\u68C0\\u75AB\\u603B\\u5C40", "\\u4E2D\\u56FD\\u56FD\\u5BB6\\u6807\\u51C6\\u5316\\u7BA1\\u7406\\u59D4\\u5458\\u4F1A"], :standard_class=>"\\u4E2D\\u534E\\u4EBA\\u6C11\\u5171\\u548C\\u56FD\\u56FD\\u5BB6\\u6807\\u51C6", :tc=>"XXXX", :updateddate=>"XXX", :wg=>"XXXX"}
    OUTPUT
end

end
