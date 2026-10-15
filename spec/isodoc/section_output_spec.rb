require "spec_helper"

RSpec.describe IsoDoc::Gb::HtmlConvert do
    it "processes clause names" do
          expect(IsoDoc::Gb::PresentationXMLConvert.new({}).convert("test", <<~"INPUT", true).sub(%r{<localized-strings>.*</localized-strings>}m, "")).to be_equivalent_to <<~"OUTPUT"
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
        <bibdata>
        <language>en</language>
        <script>Latn</script>
        </bibdata>
               <sections>
               <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
         <title>Introduction</title>
       </clause>
       <clause id="O" inline-header="true" obligation="normative">
         <title>Clause 4.2</title>
       </clause></clause>
        </sections>
    </gb-standard>
    INPUT
    <?xml version="1.0"?>
    <gb-standard xmlns="http://riboseinc.com/gbstandard" type="presentation">
        <bibdata>
        <language current="true">en</language>
        <script current="true">Latn</script>
        </bibdata>
               <preface><clause type="toc" id="_51f71510-ce18-7db8-84af-dbaa1d3c48ac" displayorder="1"><fmt-title depth="1" id="_74dc20cf-09d4-f5b8-b126-8ab19c5e2b77">Contents</fmt-title></clause>
     </preface><sections>
               <clause id="M" inline-header="false" obligation="normative" semx-id="M" displayorder="2"><title id="_788fd270-32c8-b2a7-158a-3e3b6ff43d0d"><fmt-annotation-start id="_8b0e317c-12c2-1a72-ac03-76bb7289f131" source="M" target="_db78a9f2-3cfb-912d-f582-1c34c666e4a7" end="M" author="" date="2026-10-15"/>Clause 4<fmt-annotation-end id="_5869d64f-13b7-9674-abf7-87957caecd3c" source="M" target="_db78a9f2-3cfb-912d-f582-1c34c666e4a7" start="M" author="" date="2026-10-15"/></title><fmt-title depth="1" id="_5b21e241-66d9-b139-6dbe-b394805b2a1a"><span class="fmt-caption-label"><semx element="autonum" source="M">1</semx></span><span class="fmt-caption-delim"><tab/></span><semx element="title" source="_788fd270-32c8-b2a7-158a-3e3b6ff43d0d">Clause 4</semx></fmt-title><fmt-xref-label><span class="fmt-element-name">Clause</span> <semx element="autonum" source="M">1</semx></fmt-xref-label><clause id="N" inline-header="false" obligation="normative" semx-id="N">
         <title id="_45a8786f-d4a1-36bb-95c9-25a17f463542">Introduction</title><fmt-title depth="2" id="_268ec94d-cec7-6bf4-0d01-39a3b1a035f5"><span class="fmt-caption-label"><semx element="autonum" source="M">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="N">1</semx></span><span class="fmt-caption-delim"><tab/></span><semx element="title" source="_45a8786f-d4a1-36bb-95c9-25a17f463542">Introduction</semx></fmt-title><fmt-xref-label><semx element="autonum" source="M">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="N">1</semx></fmt-xref-label>
       </clause>
       <clause id="O" inline-header="true" obligation="normative" semx-id="O">
         <title id="_c445d5f9-21da-e613-2bf7-d25c551e8fbc">Clause 4.2</title><fmt-title depth="2" id="_166deb69-8e68-834d-2b2a-efe68c63d9dd"><span class="fmt-caption-label"><semx element="autonum" source="M">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="O">2</semx></span><span class="fmt-caption-delim"><tab/></span><semx element="title" source="_c445d5f9-21da-e613-2bf7-d25c551e8fbc">Clause 4.2</semx></fmt-title><fmt-xref-label><semx element="autonum" source="M">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="O">2</semx></fmt-xref-label>
       </clause></clause>
        </sections>
    <annotation-container><annotation date="2026-10-15" reviewer="Metanorma" id="_34c75662-e908-8bc8-0b78-19d6335967b0" from="M" to="M">
    <p><strong>Metadata warnings:</strong></p> <p>Secretariat is missing.</p><p>Editorial groups are missing.</p><p>Document date is missing.</p>
    </annotation><fmt-annotation-body date="2026-10-15" reviewer="Metanorma" from="_8b0e317c-12c2-1a72-ac03-76bb7289f131" to="_5869d64f-13b7-9674-abf7-87957caecd3c" id="_db78a9f2-3cfb-912d-f582-1c34c666e4a7"><semx element="annotation" source="_34c75662-e908-8bc8-0b78-19d6335967b0">
    <p><strong>Metadata warnings:</strong></p> <p>Secretariat is missing.</p><p>Editorial groups are missing.</p><p>Document date is missing.</p>
    </semx></fmt-annotation-body>
    </annotation-container></gb-standard>
    OUTPUT
  end

        it "processes clause names, suppressing heading numbers" do
          expect(IsoDoc::Gb::PresentationXMLConvert.new({suppressheadingnumbers: true}).convert("test", <<~"INPUT", true).sub(%r{<localized-strings>.*</localized-strings>}m, "")).to be_equivalent_to <<~"OUTPUT"
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
        <bibdata>
        <language>en</language>
        <script>Latn</script>
        </bibdata>
               <sections>
               <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
         <title>Introduction</title>
       </clause>
       <clause id="O" inline-header="true" obligation="normative">
         <title>Clause 4.2</title>
       </clause></clause>
        </sections>
    </gb-standard>
    INPUT
    <?xml version="1.0"?>
    <gb-standard xmlns="http://riboseinc.com/gbstandard" type="presentation">
        <bibdata>
        <language current="true">en</language>
        <script current="true">Latn</script>
        </bibdata>
               <preface><clause type="toc" id="_51f71510-ce18-7db8-84af-dbaa1d3c48ac" displayorder="1"><fmt-title depth="1" id="_74dc20cf-09d4-f5b8-b126-8ab19c5e2b77">Contents</fmt-title></clause>
     </preface><sections>
               <clause id="M" inline-header="false" obligation="normative" semx-id="M" displayorder="2"><title id="_788fd270-32c8-b2a7-158a-3e3b6ff43d0d"><fmt-annotation-start id="_8b0e317c-12c2-1a72-ac03-76bb7289f131" source="M" target="_db78a9f2-3cfb-912d-f582-1c34c666e4a7" end="M" author="" date="2026-10-15"/>Clause 4<fmt-annotation-end id="_5869d64f-13b7-9674-abf7-87957caecd3c" source="M" target="_db78a9f2-3cfb-912d-f582-1c34c666e4a7" start="M" author="" date="2026-10-15"/></title><fmt-title depth="1" id="_d516ca28-9706-b12c-fca2-e7517cd569b0"><semx element="title" source="_788fd270-32c8-b2a7-158a-3e3b6ff43d0d">Clause 4</semx></fmt-title><clause id="N" inline-header="false" obligation="normative" semx-id="N">
         <title id="_6cfac2a1-6dab-3b74-e24f-cb8c73051465">Introduction</title><fmt-title depth="2" id="_a61e2915-df12-ce5b-9809-9a4e8ab284b6"><semx element="title" source="_6cfac2a1-6dab-3b74-e24f-cb8c73051465">Introduction</semx></fmt-title>
       </clause>
       <clause id="O" inline-header="true" obligation="normative" semx-id="O">
         <title id="_a49835e8-c93e-3a2c-3958-b2686a37bc43">Clause 4.2</title><fmt-title depth="2" id="_502d9459-6080-4756-c2d1-5c2eb5c94516"><semx element="title" source="_a49835e8-c93e-3a2c-3958-b2686a37bc43">Clause 4.2</semx></fmt-title>
       </clause></clause>
        </sections>
    <annotation-container><annotation date="2026-10-15" reviewer="Metanorma" id="_34c75662-e908-8bc8-0b78-19d6335967b0" from="M" to="M">
    <p><strong>Metadata warnings:</strong></p> <p>Secretariat is missing.</p><p>Editorial groups are missing.</p><p>Document date is missing.</p>
    </annotation><fmt-annotation-body date="2026-10-15" reviewer="Metanorma" from="_8b0e317c-12c2-1a72-ac03-76bb7289f131" to="_5869d64f-13b7-9674-abf7-87957caecd3c" id="_db78a9f2-3cfb-912d-f582-1c34c666e4a7"><semx element="annotation" source="_34c75662-e908-8bc8-0b78-19d6335967b0">
    <p><strong>Metadata warnings:</strong></p> <p>Secretariat is missing.</p><p>Editorial groups are missing.</p><p>Document date is missing.</p>
    </semx></fmt-annotation-body>
    </annotation-container></gb-standard>
    OUTPUT
  end

        it "processes annex names" do
          expect(IsoDoc::Gb::PresentationXMLConvert.new({}).convert("test", <<~"INPUT", true).sub(%r{<localized-strings>.*</localized-strings>}m, "")).to be_equivalent_to <<~"OUTPUT"
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
        <bibdata>
        <language>en</language>
        <script>Latn</script>
        </bibdata>
        <annex id="P" inline-header="false" obligation="normative">
         <title>Annex</title>
        </annex> 
    </gb-standard>
    INPUT
    <?xml version="1.0"?>
    <gb-standard xmlns="http://riboseinc.com/gbstandard" type="presentation">
        <bibdata>
        <language current="true">en</language>
        <script current="true">Latn</script>
        </bibdata>
        <preface><clause type="toc" id="_51f71510-ce18-7db8-84af-dbaa1d3c48ac" displayorder="1"><fmt-title depth="1" id="_74dc20cf-09d4-f5b8-b126-8ab19c5e2b77">Contents</fmt-title></clause>
     </preface><annex id="P" inline-header="false" obligation="normative" semx-id="P" autonum="A" displayorder="2">
         <title id="_55f59f2c-1671-fcb7-5ebf-e1ef7fe69ddf">Annex</title><fmt-title id="_5356e58e-87df-b5b0-72a7-8c75a8188868"><strong><span class="fmt-caption-label"><span class="fmt-element-name">Annex</span> <semx element="autonum" source="P">A</semx></span></strong><br/><span class="fmt-obligation">(normative)</span><span class="fmt-caption-delim"><br/><br/></span><semx element="title" source="_55f59f2c-1671-fcb7-5ebf-e1ef7fe69ddf"><strong>Annex</strong></semx></fmt-title><fmt-xref-label><span class="fmt-element-name">Annex</span> <semx element="autonum" source="P">A</semx></fmt-xref-label><variant-title type="toc"><span class="fmt-caption-label"><span class="fmt-element-name">Annex</span> <semx element="autonum" source="P">A</semx></span><span class="fmt-caption-delim"><tab/></span><semx element="title" source="_55f59f2c-1671-fcb7-5ebf-e1ef7fe69ddf">Annex</semx></variant-title>
        </annex> 
    </gb-standard>
    OUTPUT
  end

end
