require "spec_helper"


RSpec.describe Asciidoctor::Gb do
  it "processes sections" do
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true))).to be_equivalent_to <<~"OUTPUT"

      #{ASCIIDOC_BLANK_HDR}
      
      .Foreword

      Text

      == 引言

      === Introduction Subsection

      == 致谢

      == 范围

      Text

      == 规范性引用文件

      == 术语和定义

      === Term1

      == 术语、定义、符号、代号和缩略语

      === Normal Terms

      ==== Term2

      === 符号、代号和缩略语

      == 符号、代号和缩略语

      == Clause 4

      === Introduction

      === Clause 4.2

      [appendix]
      == Annex

      === Annex A.1

      [%appendix]
      === Appendix 1

      == 参考文献

      === Bibliography Subsection
    INPUT
<?xml version="1.0" encoding="UTF-8"?>
<metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="1.5.8" schema-version="v2.3.0" flavor="gb">
<bibdata type="standard">



<contributor><role type="author"/><person>
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
</organization></owner></copyright><ext><doctype>standard</doctype><structuredidentifier><project-number/></structuredidentifier><stagename>International standard</stagename><gbtype><gbscope>national</gbscope><gbprefix>GB</gbprefix><gbmandate>mandatory</gbmandate><gbtopic>basic</gbtopic></gbtype></ext></bibdata><metanorma-extension><semantic-metadata><stage-published>false</stage-published></semantic-metadata>
<presentation-metadata><document-scheme>2024</document-scheme><toc-heading-levels>2</toc-heading-levels><html-toc-heading-levels>2</html-toc-heading-levels><doc-toc-heading-levels>3</doc-toc-heading-levels><pdf-toc-heading-levels>3</pdf-toc-heading-levels></presentation-metadata></metanorma-extension>
<boilerplate>
  
</boilerplate><preface><foreword id="_" obligation="informative">
<title id="_">Foreword</title>
<p id="_">Text</p>
</foreword><introduction id="_" obligation="informative">
<title id="_">Introduction</title>
<clause id="_" inline-header="false" obligation="informative">
<title id="_">Introduction Subsection</title>
</clause>
</introduction><acknowledgements id="_" obligation="informative">
<title id="_">Acknowledgements</title>
</acknowledgements></preface><sections>


<clause id="_" type="scope" inline-header="false" obligation="normative">
<title id="_">Scope</title>
<p id="_">Text</p>
</clause>



<terms id="_" obligation="normative">
<title id="_">Terms and definitions</title><p id="_">For the purposes of this document, the following terms and definitions apply.</p><p id="_">ISO and IEC maintain terminology databases for use in standardization at the following addresses:</p>

<ul id="_"><li><p id="_">ISO Online browsing platform: available at <link target="https://www.iso.org/obp"/></p>
</li>
<li><p id="_">IEC Electropedia: available at <link target="https://www.electropedia.org"/></p>
</li>
</ul>
<term id="_" anchor="term-Term1"><preferred language="zh"><expression><name>1</name></expression></preferred> <preferred language="en"><expression><name>Term1</name></expression></preferred>
 </term>
</terms>

<clause id="_" obligation="normative" type="terms">
<title id="_">Terms, definitions, symbols and abbreviated terms</title>
<terms id="_" obligation="normative">
<title id="_">Normal Terms</title><p id="_">For the purposes of this document, the following terms and definitions apply.</p><p id="_">ISO and IEC maintain terminology databases for use in standardization at the following addresses:</p>

<ul id="_"><li><p id="_">ISO Online browsing platform: available at <link target="https://www.iso.org/obp"/></p>
</li>
<li><p id="_">IEC Electropedia: available at <link target="https://www.electropedia.org"/></p>
</li>
</ul>
<term id="_" anchor="term-Term2"><preferred language="zh"><expression><name>2</name></expression></preferred> <preferred language="en"><expression><name>Term2</name></expression></preferred>
 </term>
</terms>

<definitions id="_" obligation="normative">
<title id="_">符号、代号和缩略语</title>
</definitions></clause>

<definitions id="_" obligation="normative">
<title id="_">符号、代号和缩略语</title>
</definitions>
<clause id="_" inline-header="false" obligation="normative">
<title id="_">Clause 4</title>
<clause id="_" inline-header="false" obligation="normative">
<title id="_">Introduction</title>
</clause>

<clause id="_" inline-header="false" obligation="normative">
<title id="_">Clause 4.2</title>
</clause>
</clause>




</sections><annex id="_" inline-header="false" obligation="normative">
<title id="_">Annex</title>
<clause id="_" inline-header="false" obligation="normative">
<title id="_">Annex A.1</title>
</clause>

<clause id="_" inline-header="false" obligation="normative">
<title id="_">Appendix 1</title>
</clause>
</annex><bibliography><references id="_" normative="true" obligation="informative">
<title id="_">Normative references</title><p id="_">There are no normative references in this document.</p>
</references><clause id="_" obligation="informative">
<title id="_">Bibliography</title>
<references id="_" normative="false" obligation="informative">
<title id="_">Bibliography Subsection</title>
</references>
</clause></bibliography>
</metanorma>
OUTPUT
  end

  it "processes sections in Simplified Chinese" do
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true))).to be_equivalent_to <<~"OUTPUT"

      #{ASCIIDOC_BLANK_HDR_ZH}

      .Foreword

      Text

      == 引言

      === Introduction Subsection

      == 致谢

      == 范围

      Text

      == 规范性引用文件

      == 术语和定义

      === Term1

      == 术语、定义、符号、代号和缩略语

      === Normal Terms

      ==== Term2

      === 符号、代号和缩略语

      == 符号、代号和缩略语

      == Clause 4

      === Introduction

      === Clause 4.2

      [appendix]
      == Annex

      === Annex A.1

      [%appendix]
      === Appendix 1

      == 参考文献

      === Bibliography Subsection
    INPUT
<?xml version="1.0" encoding="UTF-8"?>
<metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="1.5.8" schema-version="v2.3.0" flavor="gb">
<bibdata type="standard">



<contributor><role type="author"/><person>
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
<name>中华人民共和国国家质量监督检验检疫总局 中国国家标准化管理委员会</name>
</organization></contributor><language>zh</language><script>Hans</script><status><stage>published</stage></status><copyright><from>2026</from><owner><organization>
<name>中华人民共和国国家质量监督检验检疫总局 中国国家标准化管理委员会</name>
</organization></owner></copyright><ext><doctype>standard</doctype><structuredidentifier><project-number/></structuredidentifier><stagename>国家标准</stagename><gbtype><gbscope>national</gbscope><gbprefix>GB</gbprefix><gbmandate>mandatory</gbmandate><gbtopic>basic</gbtopic></gbtype></ext></bibdata><metanorma-extension><semantic-metadata><stage-published>false</stage-published></semantic-metadata>
<presentation-metadata><document-scheme>2024</document-scheme><toc-heading-levels>2</toc-heading-levels><html-toc-heading-levels>2</html-toc-heading-levels><doc-toc-heading-levels>3</doc-toc-heading-levels><pdf-toc-heading-levels>3</pdf-toc-heading-levels></presentation-metadata></metanorma-extension>
<boilerplate>
  
</boilerplate><preface><foreword id="_" obligation="informative">
<title id="_">前言</title>
<p id="_">Text</p>
</foreword><introduction id="_" obligation="informative">
<title id="_">引言</title>
<clause id="_" inline-header="false" obligation="informative">
<title id="_">Introduction Subsection</title>
</clause>
</introduction><acknowledgements id="_" obligation="informative">
<title id="_">致謝</title>
</acknowledgements></preface><sections>


<clause id="_" type="scope" inline-header="false" obligation="normative">
<title id="_">范围</title>
<p id="_">Text</p>
</clause>



<terms id="_" obligation="normative">
<title id="_">术语和定义</title><p id="_">下列术语和定义适用于本文件。</p><p id="_">ISO和IEC用于标准化的术语数据库地址如下：</p><ul id="_"><li><p id="_">ISO在线浏览平台：位于https：//www。iso。org/obp［］</p>
</li>
<li><p id="_">IEC Electropedia：位于https：//www。electropedia。org［］</p>
</li>
</ul>
<term id="_" anchor="term-Term1"><preferred language="zh"><expression><name>1</name></expression></preferred> <preferred language="en"><expression><name>Term1</name></expression></preferred>
 </term>
</terms>

<clause id="_" obligation="normative" type="terms">
<title id="_">术语、定义、符号、代号和缩略语</title>
<terms id="_" obligation="normative">
<title id="_">Normal Terms</title><p id="_">下列术语和定义适用于本文件。</p><p id="_">ISO和IEC用于标准化的术语数据库地址如下：</p><ul id="_"><li><p id="_">ISO在线浏览平台：位于https：//www。iso。org/obp［］</p>
</li>
<li><p id="_">IEC Electropedia：位于https：//www。electropedia。org［］</p>
</li>
</ul>
<term id="_" anchor="term-Term2"><preferred language="zh"><expression><name>2</name></expression></preferred> <preferred language="en"><expression><name>Term2</name></expression></preferred>
 </term>
</terms>

<definitions id="_" obligation="normative">
<title id="_">符号、代号和缩略语</title>
</definitions></clause>

<definitions id="_" obligation="normative">
<title id="_">符号、代号和缩略语</title>
</definitions>
<clause id="_" inline-header="false" obligation="normative">
<title id="_">Clause 4</title>
<clause id="_" inline-header="false" obligation="normative">
<title id="_">Introduction</title>
</clause>

<clause id="_" inline-header="false" obligation="normative">
<title id="_">Clause 4.2</title>
</clause>
</clause>




</sections><annex id="_" inline-header="false" obligation="normative">
<title id="_">Annex</title>
<clause id="_" inline-header="false" obligation="normative">
<title id="_">Annex A.1</title>
</clause>

<clause id="_" inline-header="false" obligation="normative">
<title id="_">Appendix 1</title>
</clause>
</annex><bibliography><references id="_" normative="true" obligation="informative">
<title id="_">规范性引用文件</title><p id="_">本文件并没有规范性引用文件。</p>
</references><clause id="_" obligation="informative">
<title id="_">参考文献</title>
<references id="_" normative="false" obligation="informative">
<title id="_">Bibliography Subsection</title>
</references>
</clause></bibliography>
</metanorma>
OUTPUT
  end

    it "processes empty terms & definitions" do
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true))).to be_equivalent_to <<~"OUTPUT"

      #{ASCIIDOC_BLANK_HDR}

      == Terms and Definitions
      INPUT
<?xml version="1.0" encoding="UTF-8"?>
<metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="1.5.8" schema-version="v2.3.0" flavor="gb">
<bibdata type="standard">



<contributor><role type="author"/><person>
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
</organization></owner></copyright><ext><doctype>standard</doctype><structuredidentifier><project-number/></structuredidentifier><stagename>International standard</stagename><gbtype><gbscope>national</gbscope><gbprefix>GB</gbprefix><gbmandate>mandatory</gbmandate><gbtopic>basic</gbtopic></gbtype></ext></bibdata><metanorma-extension><semantic-metadata><stage-published>false</stage-published></semantic-metadata>
<presentation-metadata><document-scheme>2024</document-scheme><toc-heading-levels>2</toc-heading-levels><html-toc-heading-levels>2</html-toc-heading-levels><doc-toc-heading-levels>3</doc-toc-heading-levels><pdf-toc-heading-levels>3</pdf-toc-heading-levels></presentation-metadata></metanorma-extension>
<boilerplate>
  
</boilerplate><sections><terms id="_" obligation="normative">
<title id="_">Terms and definitions</title><p id="_">No terms and definitions are listed in this document.</p><p id="_">ISO and IEC maintain terminology databases for use in standardization at the following addresses:</p>

<ul id="_"><li><p id="_">ISO Online browsing platform: available at <link target="https://www.iso.org/obp"/></p>
</li>
<li><p id="_">IEC Electropedia: available at <link target="https://www.electropedia.org"/></p>
</li>
</ul>
</terms>
</sections>
</metanorma>
      OUTPUT

end
end
