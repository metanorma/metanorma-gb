require "spec_helper"

RSpec.describe Asciidoctor::Gb do
  it "processes sections" do
    expect(xmlpp(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)))).to be_equivalent_to xmlpp(<<~"OUTPUT")
      #{ASCIIDOC_BLANK_HDR}
      
      .Foreword

      Text

      == 引言

      === Introduction Subsection

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
            #{BLANK_HDR}
       <preface><foreword obligation="informative">
         <title>Foreword</title>
         <p id="_">Text</p>
       </foreword><introduction id="_" obligation="informative"><title>Introduction</title><clause id="_" inline-header="false" obligation="informative">
         <title>Introduction Subsection</title>
       </clause>
       </introduction></preface><sections>
     
       <clause id="_" obligation="normative">
         <title>Scope</title>
         <p id="_">Text</p>
       </clause>
     
       <terms id="_" obligation="normative">
         <title>Terms and definitions</title><p>For the purposes of this document, 
    the following terms and definitions apply.</p>
<p>ISO and IEC maintain terminological databases for use in
standardization at the following addresses:</p>

<ul>
<li> <p>ISO Online browsing platform: available at
  <link target="http://www.iso.org/obp"/></p> </li>
<li> <p>IEC Electropedia: available at
<link target="http://www.electropedia.org"/>
</p> </li> </ul>

         <term id="_">
         <preferred language="zh">1</preferred> <preferred language="en">Term1</preferred>
       </term>
       </terms>
       <clause id="_" obligation="normative"><title>Terms and definitions</title><terms id="_" obligation="normative">
         <title>Normal Terms</title>
         <term id="_">
         <preferred language="zh">2</preferred> <preferred language="en">Term2</preferred>
       </term>
       </terms>
       <definitions id="_"><title>符号、代号和缩略语</title></definitions></clause>
       <definitions id="_"><title>符号、代号和缩略语</title></definitions>
       <clause id="_" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="_" inline-header="false" obligation="normative">
         <title>Introduction</title>
       </clause>
       <clause id="_" inline-header="false" obligation="normative">
         <title>Clause 4.2</title>
       </clause></clause>
     
       </sections><annex id="_" inline-header="false" obligation="normative"><title>Annex</title><clause id="_" inline-header="false" obligation="normative">
         <title>Annex A.1</title>
       </clause>
       <clause id="_" inline-header="false" obligation="normative">
         <title>Appendix 1</title>
       </clause></annex><bibliography><references id="_" obligation="informative">
         <title>Normative References</title>
         <p>There are no normative references in this document.</p>
       </references><clause id="_" obligation="informative">
         <title>Bibliography</title>
         <references id="_" obligation="informative">
         <title>Bibliography Subsection</title>
       </references>
       </clause></bibliography>
       </gb-standard>
OUTPUT
  end

    it "processes empty terms & definitions" do
    expect(xmlpp(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)))).to be_equivalent_to xmlpp(<<~"OUTPUT")
      #{ASCIIDOC_BLANK_HDR}

      == Terms and Definitions
      INPUT
      #{BLANK_HDR}
      <sections>
  <terms id="_" obligation="normative">
  <title>Terms and definitions</title><p>No terms and definitions are listed in this document.</p>
<p>ISO and IEC maintain terminological databases for use in
standardization at the following addresses:</p>

<ul>
<li> <p>ISO Online browsing platform: available at
  <link target="http://www.iso.org/obp"/></p> </li>
<li> <p>IEC Electropedia: available at
<link target="http://www.electropedia.org"/>
</p> </li> </ul>

</terms>
</sections>
</gb-standard>
      OUTPUT

end
end
