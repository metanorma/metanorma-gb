require "spec_helper"

RSpec.describe Asciidoctor::Gb do
  it "processes sections" do
    expect(xmlpp(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
            #{BLANK_HDR}
       <preface><foreword id="_" obligation="informative">
         <title>Foreword</title>
         <p id="_">Text</p>
       </foreword><introduction id="_" obligation="informative"><title>Introduction</title><clause id="_" inline-header="false" obligation="informative">
         <title>Introduction Subsection</title>
       </clause>
       </introduction>
       <acknowledgements id='_' obligation='informative'>
  <title>Acknowledgements</title>
</acknowledgements>
</preface><sections>
     
       <clause id="_" obligation="normative" type="scope" inline-header='false' >
         <title>Scope</title>
         <p id="_">Text</p>
       </clause>
     
       <terms id="_" obligation="normative">
         <title>Terms and definitions</title><p id="_">For the purposes of this document, 
    the following terms and definitions apply.</p>
<p id="_">ISO and IEC maintain terminological databases for use in
standardization at the following addresses:</p>

<ul id="_">
<li> <p id="_">ISO Online browsing platform: available at
  <link target="http://www.iso.org/obp"/></p> </li>
<li> <p id="_">IEC Electropedia: available at
<link target="http://www.electropedia.org"/>
</p> </li> </ul>

         <term id="term-term1">
         <preferred language="zh">1</preferred> <preferred language="en">Term1</preferred>
       </term>
       </terms>
       <clause id="_" obligation="normative"><title>Terms, definitions, symbols and abbreviated terms</title>
<terms id="_" obligation="normative">
         <title>Normal Terms</title>
       <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
<p id='_'>
  ISO and IEC maintain terminological databases for use in standardization
  at the following addresses:
</p>
<ul id='_'>
  <li>
    <p id='_'>
      ISO Online browsing platform: available at
      <link target='http://www.iso.org/obp'/>
    </p>
  </li>
  <li>
    <p id='_'>
      IEC Electropedia: available at
      <link target='http://www.electropedia.org'/>
    </p>
  </li>
</ul>
         <term id="term-term2">
         <preferred language="zh">2</preferred> <preferred language="en">Term2</preferred>
       </term>
       </terms>
       <definitions id="_" obligation="normative"><title>Symbols and abbreviated terms</title></definitions></clause>
       <definitions id="_" obligation="normative"><title>Symbols and abbreviated terms</title></definitions>
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
       </clause></annex><bibliography><references id="_" obligation="informative" normative="true">
         <title>Normative references</title>
         <p id="_">There are no normative references in this document.</p>
       </references><clause id="_" obligation="informative">
         <title>Bibliography</title>
         <references id="_" obligation="informative" normative="false">
         <title>Bibliography Subsection</title>
       </references>
       </clause></bibliography>
       </gb-standard>
OUTPUT
  end

  it "processes sections in Simplified Chinese" do
    expect(xmlpp(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
    <gb-standard xmlns='https://www.metanorma.org/ns/gb'  type="semantic" version="#{Metanorma::Gb::VERSION}">
         <bibdata type='standard'>
           <contributor>
             <role type='author'/>
             <person>
               <name>
                 <surname>Author</surname>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='author'/>
             <organization>
               <name>GB</name>
             </organization>
           </contributor>
           <contributor>
             <role type='publisher'/>
             <organization>
               <name>GB</name>
             </organization>
           </contributor>
           <contributor>
             <role type='authority'/>
             <organization>
               <name>GB</name>
             </organization>
           </contributor>
           <contributor>
             <role type='proposer'/>
             <organization>
               <name>GB</name>
             </organization>
           </contributor>
           <contributor>
             <role type='issuer'/>
             <organization>
               <name>中华人民共和国国家质量监督检验检疫总局 中国国家标准化管理委员会</name>
             </organization>
           </contributor>
           <language>zh</language>
           <script>Hans</script>
           <status>
             <stage abbreviation='IS'>60</stage>
             <substage>60</substage>
           </status>
           <copyright>
             <from>2020</from>
             <owner>
               <organization>
                 <name>中华人民共和国国家质量监督检验检疫总局 中国国家标准化管理委员会</name>
               </organization>
             </owner>
           </copyright>
           <ext>
             <doctype>standard</doctype>
             <structuredidentifier>
               <project-number/>
             </structuredidentifier>
             <stagename>国家标准</stagename>
             <gbtype>
               <gbscope>national</gbscope>
               <gbprefix>GB</gbprefix>
               <gbmandate>mandatory</gbmandate>
               <gbtopic>basic</gbtopic>
             </gbtype>
           </ext>
         </bibdata>
         <boilerplate> </boilerplate>
         <preface>
           <foreword id='_' obligation='informative'>
             <title>前言</title>
             <p id='_'>Text</p>
           </foreword>
           <introduction id='_' obligation='informative'>
             <title>引言</title>
             <clause id='_' inline-header='false' obligation='informative'>
               <title>Introduction Subsection</title>
             </clause>
           </introduction>
           <acknowledgements id='_' obligation='informative'>
             <title>致謝</title>
           </acknowledgements>
         </preface>
         <sections>
           <clause id='_' type='scope' inline-header='false' obligation='normative'>
             <title>范围</title>
             <p id='_'>Text</p>
           </clause>
           <terms id='_' obligation='normative'>
             <title>术语和定义</title>
             <p id='_'>下列术语和定义适用于本文件。</p>
             <p id='_'>ISO和IEC用于标准化的术语数据库地址如下：</p>
             <ul id='_'>
               <li>
                 <p id='_'>
                   ISO在线浏览平台: 位于
                   <link target='http://www.iso.org/obp'/>
                 </p>
               </li>
               <li>
                 <p id='_'>
                   IEC Electropedia: 位于
                   <link target='http://www.electropedia.org'/>
                 </p>
               </li>
             </ul>
             <term id='term-term1'>
               <preferred language='zh'>1</preferred>
               <preferred language='en'>Term1</preferred>
             </term>
           </terms>
           <clause id='_' obligation='normative'>
             <title>术语、定义、符号、代号和缩略语</title>
             <terms id='_' obligation='normative'>
               <title>Normal Terms</title>
               <p id='_'>下列术语和定义适用于本文件。</p>
               <p id='_'>ISO和IEC用于标准化的术语数据库地址如下：</p>
               <ul id='_'>
                 <li>
                   <p id='_'>
                     ISO在线浏览平台: 位于
                     <link target='http://www.iso.org/obp'/>
                   </p>
                 </li>
                 <li>
                   <p id='_'>
                     IEC Electropedia: 位于
                     <link target='http://www.electropedia.org'/>
                   </p>
                 </li>
               </ul>
               <term id='term-term2'>
                 <preferred language='zh'>2</preferred>
                 <preferred language='en'>Term2</preferred>
               </term>
             </terms>
             <definitions id='_' obligation='normative'>
               <title>符号、代号和缩略语</title>
             </definitions>
           </clause>
           <definitions id='_' obligation='normative'>
             <title>符号、代号和缩略语</title>
           </definitions>
           <clause id='_' inline-header='false' obligation='normative'>
             <title>Clause 4</title>
             <clause id='_' inline-header='false' obligation='normative'>
               <title>Introduction</title>
             </clause>
             <clause id='_' inline-header='false' obligation='normative'>
               <title>Clause 4.2</title>
             </clause>
           </clause>
         </sections>
         <annex id='_' inline-header='false' obligation='normative'>
           <title>Annex</title>
           <clause id='_' inline-header='false' obligation='normative'>
             <title>Annex A.1</title>
           </clause>
           <clause id='_' inline-header='false' obligation='normative'>
             <title>Appendix 1</title>
           </clause>
         </annex>
         <bibliography>
           <references id='_' normative='true' obligation='informative'>
             <title>规范性引用文件</title>
             <p id='_'>本文件并没有规范性引用文件。</p>
           </references>
           <clause id='_' obligation='informative'>
             <title>参考文献</title>
             <references id='_' normative='false' obligation='informative'>
               <title>Bibliography Subsection</title>
             </references>
           </clause>
         </bibliography>
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
  <title>Terms and definitions</title><p id="_">No terms and definitions are listed in this document.</p>
<p id="_">ISO and IEC maintain terminological databases for use in
standardization at the following addresses:</p>

<ul id="_">
<li> <p id="_">ISO Online browsing platform: available at
  <link target="http://www.iso.org/obp"/></p> </li>
<li> <p id="_">IEC Electropedia: available at
<link target="http://www.electropedia.org"/>
</p> </li> </ul>

</terms>
</sections>
</gb-standard>
      OUTPUT

end
end
