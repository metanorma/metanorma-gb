require "spec_helper"


RSpec.describe Asciidoctor::Gb do
  it "processes metadata" do
    expect(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)).to be_equivalent_to <<~"OUTPUT"

      = Document title
      Author
      :docfile: test.adoc
      :mandate: mandatory
      :author: Fred Bloggs, Joe Schmoe
      :copyright-year: 1999
      :technical-committee-type: Governance
      :technical-committee: Technical
      :iso-standard: ISO 1012
      :obsoletes: GB/T 134, Source Frequency Regulation
      :obsoletes-parts: Section 3-5
      :scope: national
      :topic: Radio
      :published-date: 2018-01-01
      :library-ccs: 12, 34
      :library-plan: AB
      :author-committee: AC
      :author-committee_2: BC
      :publisher: P
      :authority: Q
      :proposer: X
      :issuer: Y
      :title-intro-en: Title 1
      :title-main-en: Title 2
      :title-part-en: Title 3
      :title-intro-zh: Title 4
      :title-main-zh: Title 5
      :title-part-zh: Title 6
      :docnumber: 123
      :nodoc:
      :novalid:

    INPUT
<?xml version="1.0" encoding="UTF-8"?>
<metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="1.5.8" schema-version="v2.3.0" flavor="gb">
<bibdata type="standard">
<title language="en" format="plain" type="main">Title 1 — Title 2 — Title 3</title>

<title language="en" format="plain" type="title-intro">Title 1</title>

<title language="en" format="plain" type="title-main">Title 2</title>

<title language="en" format="plain" type="title-part">Title 3</title>

<title language="zh" format="plain" type="main">Title 4 — Title 5 — Title 6</title>

<title language="zh" format="plain" type="title-intro">Title 4</title>

<title language="zh" format="plain" type="title-main">Title 5</title>

<title language="zh" format="plain" type="title-part">Title 6</title>
<docidentifier type="gb">GB 123-1999</docidentifier><docnumber>123</docnumber><date type="published"><on>2018-01-01</on></date><contributor><role type="author"/><person>
<name><surname>Fred Bloggs</surname></name>
</person></contributor><contributor><role type="technical-committee"/><organization><name>Technical</name></organization></contributor><contributor><role type="author"/><person>
<name><surname>Joe Schmoe</surname></name>
</person></contributor><contributor><role type="author"/><organization>
<name>AC</name>
</organization></contributor><contributor><role type="author"/><organization>
<name>BC</name>
</organization></contributor><contributor><role type="publisher"/><organization>
<name>P</name>
</organization></contributor><contributor><role type="authority"/><organization>
<name>Q</name>
</organization></contributor><contributor><role type="proposer"/><organization>
<name>X</name>
</organization></contributor><contributor><role type="issuer"/><organization>
<name>Y</name>
</organization></contributor><language>zh</language><script>Hans</script><status><stage>published</stage></status><copyright><from>1999</from><owner><organization>
<name>Y</name>
</organization></owner></copyright><relation type="adoptedFrom"><description>equivalent</description><bibitem>
<title>[not supplied]</title>
<docidentifier>ISO 1012</docidentifier></bibitem>
</relation><relation type="obsoletes"><bibitem>
<title> Source Frequency Regulation</title>
<docidentifier>GB/T 134</docidentifier></bibitem>
<localityStack><locality type="section"><referenceFrom>3</referenceFrom><referenceTo>5</referenceTo></locality></localityStack></relation><ext><doctype>standard</doctype><gbcommittee type="Governance">Technical</gbcommittee><structuredidentifier><project-number>GB 123</project-number></structuredidentifier><stagename>国家标准</stagename><gbtype><gbscope>national</gbscope><gbprefix>GB</gbprefix><gbmandate>mandatory</gbmandate><gbtopic>Radio</gbtopic></gbtype><ccs>12</ccs><ccs>34</ccs><plannumber>AB</plannumber></ext></bibdata><metanorma-extension><semantic-metadata><stage-published>false</stage-published></semantic-metadata>
<presentation-metadata><document-scheme>1989</document-scheme><toc-heading-levels>2</toc-heading-levels><html-toc-heading-levels>2</html-toc-heading-levels><doc-toc-heading-levels>3</doc-toc-heading-levels><pdf-toc-heading-levels>3</pdf-toc-heading-levels></presentation-metadata></metanorma-extension>
<boilerplate>
  
</boilerplate><sections> </sections>
</metanorma>
    OUTPUT
  end

  it "processes metadata" do
    expect(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)).to be_equivalent_to <<~"OUTPUT"

      = Document title
      Author
      :docfile: test.adoc
      :mandate: recommendation
      :iso-standard: ISO 1012, Televisual Frequencies
      :equivalence: nonequivalent
      :prefix: T/AAA
      :docnumber: 123
      :language: en
      :script: Latn
      :nodoc:
      :novalid:

    INPUT
<?xml version="1.0" encoding="UTF-8"?>
<metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="1.5.8" schema-version="v2.3.0" flavor="gb">
<bibdata type="standard">



<docidentifier type="gb">T/AAA 123</docidentifier><docnumber>123</docnumber><contributor><role type="author"/><person>
<name><surname>Author</surname></name>
</person></contributor><contributor><role type="author"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="publisher"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="authority"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="proposer"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="issuer"/><organization>
<name>GB</name>
</organization></contributor><language>en</language><script>Latn</script><status><stage>published</stage></status><copyright><from>2026</from><owner><organization>
<name>GB</name>
</organization></owner></copyright><relation type="adoptedFrom"><description>nonequivalent</description><bibitem>
<title> Televisual Frequencies</title>
<docidentifier>ISO 1012</docidentifier></bibitem>
</relation><ext><doctype>recommendation</doctype><structuredidentifier><project-number>T/AAA 123</project-number></structuredidentifier><stagename>International standard</stagename><gbtype><gbscope>social-group</gbscope><gbprefix>AAA</gbprefix><gbmandate>recommendation</gbmandate><gbtopic>basic</gbtopic></gbtype></ext></bibdata><metanorma-extension><semantic-metadata><stage-published>false</stage-published></semantic-metadata>
<presentation-metadata><document-scheme>2024</document-scheme><toc-heading-levels>2</toc-heading-levels><html-toc-heading-levels>2</html-toc-heading-levels><doc-toc-heading-levels>3</doc-toc-heading-levels><pdf-toc-heading-levels>3</pdf-toc-heading-levels></presentation-metadata></metanorma-extension>
<boilerplate>
  
</boilerplate><sections> </sections>
</metanorma>
    OUTPUT
  end

  it "processes metadata" do
    expect(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)).to be_equivalent_to <<~"OUTPUT"

      = Document title
      Author
      :docfile: test.adoc
      :prefix: Q/Z/BBB
      :docnumber: 123
      :nodoc:
      :novalid:

    INPUT
<?xml version="1.0" encoding="UTF-8"?>
<metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="1.5.8" schema-version="v2.3.0" flavor="gb">
<bibdata type="standard">



<docidentifier type="gb">Q/BBB 123</docidentifier><docnumber>123</docnumber><contributor><role type="author"/><person>
<name><surname>Author</surname></name>
</person></contributor><contributor><role type="author"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="publisher"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="authority"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="proposer"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="issuer"/><organization>
<name>GB</name>
</organization></contributor><language>zh</language><script>Hans</script><status><stage>published</stage></status><copyright><from>2026</from><owner><organization>
<name>GB</name>
</organization></owner></copyright><ext><doctype>standard</doctype><structuredidentifier><project-number>Q/BBB 123</project-number></structuredidentifier><stagename>国家标准</stagename><gbtype><gbscope>enterprise</gbscope><gbprefix>BBB</gbprefix><gbmandate>mandatory</gbmandate><gbtopic>basic</gbtopic></gbtype></ext></bibdata><metanorma-extension><semantic-metadata><stage-published>false</stage-published></semantic-metadata>
<presentation-metadata><document-scheme>2024</document-scheme><toc-heading-levels>2</toc-heading-levels><html-toc-heading-levels>2</html-toc-heading-levels><doc-toc-heading-levels>3</doc-toc-heading-levels><pdf-toc-heading-levels>3</pdf-toc-heading-levels></presentation-metadata></metanorma-extension>
<boilerplate>
  
</boilerplate><sections> </sections>
</metanorma>
    OUTPUT
  end

  it "processes metadata" do
    expect(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)).to be_equivalent_to <<~"OUTPUT"

      = Document title
      Author
      :docfile: test.adoc
      :mandate: guide
      :docnumber: 123
      :nodoc:
      :novalid:
      :language: en
      :script: Latn

    INPUT
<?xml version="1.0" encoding="UTF-8"?>
<metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="1.5.8" schema-version="v2.3.0" flavor="gb">
<bibdata type="standard">



<docidentifier type="gb">GB/Z 123</docidentifier><docnumber>123</docnumber><contributor><role type="author"/><person>
<name><surname>Author</surname></name>
</person></contributor><contributor><role type="author"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="publisher"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="authority"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="proposer"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="issuer"/><organization>
<name>General Administration of Quality Supervision, Inspection and Quarantine; Standardization Administration of China</name>
</organization></contributor><language>en</language><script>Latn</script><status><stage>published</stage></status><copyright><from>2026</from><owner><organization>
<name>General Administration of Quality Supervision, Inspection and Quarantine; Standardization Administration of China</name>
</organization></owner></copyright><ext><doctype>guide</doctype><structuredidentifier><project-number>GB/Z 123</project-number></structuredidentifier><stagename>International standard</stagename><gbtype><gbscope>national</gbscope><gbprefix>GB</gbprefix><gbmandate>guide</gbmandate><gbtopic>basic</gbtopic></gbtype></ext></bibdata><metanorma-extension><semantic-metadata><stage-published>false</stage-published></semantic-metadata>
<presentation-metadata><document-scheme>2024</document-scheme><toc-heading-levels>2</toc-heading-levels><html-toc-heading-levels>2</html-toc-heading-levels><doc-toc-heading-levels>3</doc-toc-heading-levels><pdf-toc-heading-levels>3</pdf-toc-heading-levels></presentation-metadata></metanorma-extension>
<boilerplate>
  
</boilerplate><sections> </sections>
</metanorma>
    OUTPUT
  end

  it "processes metadata" do
    expect(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)).to be_equivalent_to <<~"OUTPUT"

      = Document title
      Author
      :docfile: test.adoc
      :scope: local
      :prefix: DB81/T
      :docnumber: 123
      :nodoc:
      :novalid:
      :language: en
      :script: Latn

    INPUT
<?xml version="1.0" encoding="UTF-8"?>
<metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="1.5.8" schema-version="v2.3.0" flavor="gb">
<bibdata type="standard">



<docidentifier type="gb">DB81/123</docidentifier><docnumber>123</docnumber><contributor><role type="author"/><person>
<name><surname>Author</surname></name>
</person></contributor><contributor><role type="author"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="publisher"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="authority"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="proposer"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="issuer"/><organization>
<name>Hong Kong Special Administrative Region</name>
</organization></contributor><language>en</language><script>Latn</script><status><stage>published</stage></status><copyright><from>2026</from><owner><organization>
<name>Hong Kong Special Administrative Region</name>
</organization></owner></copyright><ext><doctype>standard</doctype><structuredidentifier><project-number>DB81/123</project-number></structuredidentifier><stagename>International standard</stagename><gbtype><gbscope>local</gbscope><gbprefix>81</gbprefix><gbmandate>mandatory</gbmandate><gbtopic>basic</gbtopic></gbtype></ext></bibdata><metanorma-extension><semantic-metadata><stage-published>false</stage-published></semantic-metadata>
<presentation-metadata><document-scheme>2024</document-scheme><toc-heading-levels>2</toc-heading-levels><html-toc-heading-levels>2</html-toc-heading-levels><doc-toc-heading-levels>3</doc-toc-heading-levels><pdf-toc-heading-levels>3</pdf-toc-heading-levels></presentation-metadata></metanorma-extension>
<boilerplate>
  
</boilerplate><sections> </sections>
</metanorma>
    OUTPUT
  end

  it "processes metadata" do
    expect(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)).to be_equivalent_to <<~"OUTPUT"

      = Document title
      Author
      :docfile: test.adoc
      :scope: local
      :prefix: GB/Z
      :docnumber: 123
      :nodoc:
      :novalid:

    INPUT
<?xml version="1.0" encoding="UTF-8"?>
<metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="1.5.8" schema-version="v2.3.0" flavor="gb">
<bibdata type="standard">



<docidentifier type="gb">DBGB/123</docidentifier><docnumber>123</docnumber><contributor><role type="author"/><person>
<name><surname>Author</surname></name>
</person></contributor><contributor><role type="author"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="publisher"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="authority"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="proposer"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="issuer"/><organization>
<name>GB</name>
</organization></contributor><language>zh</language><script>Hans</script><status><stage>published</stage></status><copyright><from>2026</from><owner><organization>
<name>GB</name>
</organization></owner></copyright><ext><doctype>standard</doctype><structuredidentifier><project-number>DBGB/123</project-number></structuredidentifier><stagename>国家标准</stagename><gbtype><gbscope>local</gbscope><gbprefix>GB</gbprefix><gbmandate>mandatory</gbmandate><gbtopic>basic</gbtopic></gbtype></ext></bibdata><metanorma-extension><semantic-metadata><stage-published>false</stage-published></semantic-metadata>
<presentation-metadata><document-scheme>2024</document-scheme><toc-heading-levels>2</toc-heading-levels><html-toc-heading-levels>2</html-toc-heading-levels><doc-toc-heading-levels>3</doc-toc-heading-levels><pdf-toc-heading-levels>3</pdf-toc-heading-levels></presentation-metadata></metanorma-extension>
<boilerplate>
  
</boilerplate><sections> </sections>
</metanorma>
    OUTPUT
  end

  it "processes metadata" do
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true))).to be_equivalent_to <<~"OUTPUT"

      = Document title
      Author
      :docfile: test.adoc
      :scope: local
      :prefix: GB
      :docnumber: 123
      :nodoc:
      :novalid:
      :status: 30
      :language: en

    INPUT
<?xml version="1.0" encoding="UTF-8"?>
<metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="1.5.8" schema-version="v2.3.0" flavor="gb">
<bibdata type="standard">



<docidentifier type="gb">DBGB/123</docidentifier><docnumber>123</docnumber><contributor><role type="author"/><person>
<name><surname>Author</surname></name>
</person></contributor><contributor><role type="author"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="publisher"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="authority"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="proposer"/><organization>
<name>GB</name>
</organization></contributor><contributor><role type="issuer"/><organization>
<name>GB</name>
</organization></contributor><language>en</language><script>Latn</script><status><stage>30</stage></status><copyright><from>2026</from><owner><organization>
<name>GB</name>
</organization></owner></copyright><ext><doctype>standard</doctype><structuredidentifier><project-number>DBGB/123</project-number></structuredidentifier><stagename>Committee draft</stagename><gbtype><gbscope>local</gbscope><gbprefix>GB</gbprefix><gbmandate>mandatory</gbmandate><gbtopic>basic</gbtopic></gbtype></ext></bibdata><metanorma-extension><semantic-metadata><stage-published>false</stage-published></semantic-metadata>
<presentation-metadata><document-scheme>2024</document-scheme><toc-heading-levels>2</toc-heading-levels><html-toc-heading-levels>2</html-toc-heading-levels><doc-toc-heading-levels>3</doc-toc-heading-levels><pdf-toc-heading-levels>3</pdf-toc-heading-levels></presentation-metadata></metanorma-extension>
<boilerplate>
  
  <legal-statement>
    <clause>
      
      <p id="_">在提交反馈意见时，请将您知道的相关专利连同支持文件一并附上。</p>
      
    </clause>
  </legal-statement>
  
</boilerplate><sections> </sections>
</metanorma>
    OUTPUT
  end

end
