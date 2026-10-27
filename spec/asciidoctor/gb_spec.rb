require "spec_helper"

require "fileutils"
require "relaton/gb"

RSpec.describe Asciidoctor::Gb do
  it "has a version number" do
    expect(Metanorma::Gb::VERSION).not_to be nil
  end

  it "processes a blank document" do
    expect(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)).to be_equivalent_to <<~"OUTPUT"

    #{ASCIIDOC_BLANK_HDR}
    INPUT
      <?xml version='1.0' encoding='UTF-8'?>
      <metanorma xmlns='https://www.metanorma.org/ns/standoc' type='semantic' version="#{Metanorma::Gb::VERSION}" schema-version='v2.3.0' flavor='gb'>
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
              <name>
                General Administration of Quality Supervision, Inspection and
                Quarantine; Standardization Administration of China
              </name>
            </organization>
          </contributor>
          <language>en</language>
          <script>Latn</script>
          <status>
            <stage>published</stage>
          </status>
          <copyright>
            <from>#{Date.today.year}</from>
            <owner>
              <organization>
                <name>
                  General Administration of Quality Supervision, Inspection and
                  Quarantine; Standardization Administration of China
                </name>
              </organization>
            </owner>
          </copyright>
          <ext>
            <doctype>standard</doctype>
            <structuredidentifier>
              <project-number/>
            </structuredidentifier>
            <stagename>International standard</stagename>
            <gbtype>
              <gbscope>national</gbscope>
              <gbprefix>GB</gbprefix>
              <gbmandate>mandatory</gbmandate>
              <gbtopic>basic</gbtopic>
            </gbtype>
          </ext>
        </bibdata>
        <metanorma-extension>
          <semantic-metadata>
            <stage-published>false</stage-published>
          </semantic-metadata>
          <presentation-metadata>
            <document-scheme>2024</document-scheme>
            <toc-heading-levels>2</toc-heading-levels>
            <html-toc-heading-levels>2</html-toc-heading-levels>
            <doc-toc-heading-levels>3</doc-toc-heading-levels>
            <pdf-toc-heading-levels>3</pdf-toc-heading-levels>
          </presentation-metadata>
        </metanorma-extension>
        <boilerplate> </boilerplate>
        <sections> </sections>
      </metanorma>
    OUTPUT
  end

  it "converts a blank document" do
    FileUtils.rm_f "test.html"
    FileUtils.rm_f "test.doc"
    FileUtils.rm_f "test.pdf"
    css_before = File.read("htmlstyle.css")
    expect(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)).to be_equivalent_to <<~"OUTPUT"

      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-isobib:
      :language: en
      :script: Latn
    INPUT
      <?xml version='1.0' encoding='UTF-8'?>
      <metanorma xmlns='https://www.metanorma.org/ns/standoc' type='semantic' version="#{Metanorma::Gb::VERSION}" schema-version='v2.3.0' flavor='gb'>
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
              <name>
                General Administration of Quality Supervision, Inspection and
                Quarantine; Standardization Administration of China
              </name>
            </organization>
          </contributor>
          <language>en</language>
          <script>Latn</script>
          <status>
            <stage>published</stage>
          </status>
          <copyright>
            <from>#{Date.today.year}</from>
            <owner>
              <organization>
                <name>
                  General Administration of Quality Supervision, Inspection and
                  Quarantine; Standardization Administration of China
                </name>
              </organization>
            </owner>
          </copyright>
          <ext>
            <doctype>standard</doctype>
            <structuredidentifier>
              <project-number/>
            </structuredidentifier>
            <stagename>International standard</stagename>
            <gbtype>
              <gbscope>national</gbscope>
              <gbprefix>GB</gbprefix>
              <gbmandate>mandatory</gbmandate>
              <gbtopic>basic</gbtopic>
            </gbtype>
          </ext>
        </bibdata>
        <metanorma-extension>
          <semantic-metadata>
            <stage-published>false</stage-published>
          </semantic-metadata>
          <presentation-metadata>
            <document-scheme>2024</document-scheme>
            <toc-heading-levels>2</toc-heading-levels>
            <html-toc-heading-levels>2</html-toc-heading-levels>
            <doc-toc-heading-levels>3</doc-toc-heading-levels>
            <pdf-toc-heading-levels>3</pdf-toc-heading-levels>
          </presentation-metadata>
        </metanorma-extension>
        <boilerplate> </boilerplate>
        <sections> </sections>
      </metanorma>
    OUTPUT
    expect(File.exist?("test.html")).to be true
    expect(File.exist?("test.doc")).to be true
    expect(File.exist?("test.pdf")).to be true
    expect(File.read("htmlstyle.css")).to eq css_before
  end

  it "uses Roman fonts" do
    FileUtils.rm_f "test.doc"
    Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Latn
      :no-pdf:

    INPUT
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^{]+font-family: "Courier New", monospace;]m)
    expect(html).to match(%r[body[^{]+\{[^{]+font-family: "Cambria", serif;]m)
    expect(html).to match(%r[\.h2Annex[^{]+\{[^{]+font-family: "Calibri", sans-serif;]m)
    expect(html).to match(%r[\.standard_class[^{]+\{[^{]+font-family: "Cambria", serif;]m)
  end

  it "uses Roman fonts, local scope" do
    FileUtils.rm_f "test.doc"
    Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Latn
      :scope: local
      :no-pdf:

    INPUT
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^{]+font-family: "Courier New", monospace;]m)
    expect(html).to match(%r[body[^{]+\{[^{]+font-family: "Cambria", serif;]m)
    expect(html).to match(%r[\.h2Annex[^{]+\{[^{]+font-family: "Calibri", sans-serif;]m)
    expect(html).to match(%r[\.standard_class[^{]+\{[^{]+font-family: "Calibri", sans-serif;]m)
  end

  it "uses default Chinese fonts" do
    FileUtils.rm_f "test.doc"
    Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:

    INPUT
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^{]+font-family: "Courier New", monospace;]m)
    expect(html).to match(%r[body[^{]+\{[^{]+font-family: "SimSun", serif;]m)
    expect(html).to match(%r[\.h2Annex[^{]+\{[^{]+font-family: "SimHei", sans-serif;]m)
    expect(html).to match(%r[\.standard_class[^{]+\{[^{]+font-family: "SimSun", serif;]m)
  end

  it "uses Chinese fonts, local scope" do
    FileUtils.rm_f "test.doc"
    Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
      :scope: local
      :no-pdf:

    INPUT
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^{]+font-family: "Courier New", monospace;]m)
    expect(html).to match(%r[body[^{]+\{[^{]+font-family: "SimSun", serif;]m)
    expect(html).to match(%r[\.h2Annex[^{]+\{[^{]+font-family: "SimHei", sans-serif;]m)
    expect(html).to match(%r[\.standard_class[^{]+\{[^{]+font-family: "SimHei", sans-serif;]m)
  end

  it "uses specified fonts" do
    FileUtils.rm_f "test.doc"
    Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
      :body-font: Zapf Chancery
      :header-font: Comic Sans
      :monospace-font: Andale Mono
      :title-font: Symbol
      :no-pdf:

    INPUT
    html = File.read("test.doc", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^{]+font-family: Andale Mono;]m)
    expect(html).to match(%r[body[^{]+\{[^{]+font-family: Zapf Chancery;]m)
    expect(html).to match(%r[\.h2Annex[^{]+\{[^{]+font-family: Comic Sans;]m)
    expect(html).to match(%r[\.standard_class[^{]+\{[^{]+font-family: Symbol;]m)
  end

  it "uses specified images" do
    Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
      :standard-logo-img: spec/asciidoctor/examples/a.gif
      :standard-class-img: spec/asciidoctor/examples/b.gif
      :standard-issuer-img: spec/asciidoctor/examples/c.gif
      :no-pdf:

    INPUT
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match %r{<div class="coverpage-logo-gb-img"><img class="logo" width="113" height="56" src="data:image/gif;base64,[^"]+" alt="GB" /></div>}
    expect(html).to match %r{<span class="coverpage-logo-text"><img class="logo" src="data:image/gif;base64,[^"]+" alt="[^"]*" width="18" height="18" /></span>}
    expect(html).to match %r{<img class="logo" src="data:image/gif;base64,[^"]+" alt="[^"]*" width="18" height="18" />}
  end

  it "does contributor cleanup" do
    FileUtils.rm_f "test.doc"
    expect(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)).to be_equivalent_to <<~"OUTPUT"

      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :nodoc:
      :language: en
      :script: Latn
      :scope: sector
      :prefix: NY
      :docnumber: 123
      :technical-committee-type: Governance
      :technical-committee: Technical


    INPUT
      <?xml version='1.0' encoding='UTF-8'?>
      <metanorma xmlns='https://www.metanorma.org/ns/standoc' type='semantic' version="#{Metanorma::Gb::VERSION}" schema-version='v2.3.0' flavor='gb'>
        <bibdata type='standard'>
          <docidentifier type='gb'>NY 123</docidentifier>
          <docnumber>123</docnumber>
          <contributor>
            <role type='author'/>
            <person>
              <name>
                <surname>Author</surname>
              </name>
            </person>
          </contributor>
          <contributor>
            <role type='technical-committee'/>
            <organization>
              <name>Technical</name>
            </organization>
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
              <name>Ministry of Agriculture</name>
            </organization>
          </contributor>
          <language>en</language>
          <script>Latn</script>
          <status>
            <stage>published</stage>
          </status>
          <copyright>
            <from>#{Date.today.year}</from>
            <owner>
              <organization>
                <name>Ministry of Agriculture</name>
              </organization>
            </owner>
          </copyright>
          <ext>
            <doctype>standard</doctype>
            <gbcommittee type='Governance'>Technical</gbcommittee>
            <structuredidentifier>
              <project-number>NY 123</project-number>
            </structuredidentifier>
            <stagename>International standard</stagename>
            <gbtype>
              <gbscope>sector</gbscope>
              <gbprefix>NY</gbprefix>
              <gbmandate>mandatory</gbmandate>
              <gbtopic>basic</gbtopic>
            </gbtype>
          </ext>
        </bibdata>
        <metanorma-extension>
          <semantic-metadata>
            <stage-published>false</stage-published>
          </semantic-metadata>
          <presentation-metadata>
            <document-scheme>2024</document-scheme>
            <toc-heading-levels>2</toc-heading-levels>
            <html-toc-heading-levels>2</html-toc-heading-levels>
            <doc-toc-heading-levels>3</doc-toc-heading-levels>
            <pdf-toc-heading-levels>3</pdf-toc-heading-levels>
          </presentation-metadata>
        </metanorma-extension>
        <boilerplate> </boilerplate>
        <sections> </sections>
      </metanorma>
    OUTPUT
  end

    it "strips any initial boilerplate from terms and definitions" do
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true))).to be_equivalent_to <<~"OUTPUT"

      #{ASCIIDOC_BLANK_HDR}
      == Terms and Definitions

      I am boilerplate

      * So am I

      === Time

      This paragraph is extraneous
    INPUT
      <?xml version='1.0' encoding='UTF-8'?>
      <metanorma xmlns='https://www.metanorma.org/ns/standoc' type='semantic' version="#{Metanorma::Gb::VERSION}" schema-version='v2.3.0' flavor='gb'>
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
              <name>
                General Administration of Quality Supervision, Inspection and
                Quarantine; Standardization Administration of China
              </name>
            </organization>
          </contributor>
          <language>en</language>
          <script>Latn</script>
          <status>
            <stage>published</stage>
          </status>
          <copyright>
            <from>#{Date.today.year}</from>
            <owner>
              <organization>
                <name>
                  General Administration of Quality Supervision, Inspection and
                  Quarantine; Standardization Administration of China
                </name>
              </organization>
            </owner>
          </copyright>
          <ext>
            <doctype>standard</doctype>
            <structuredidentifier>
              <project-number/>
            </structuredidentifier>
            <stagename>International standard</stagename>
            <gbtype>
              <gbscope>national</gbscope>
              <gbprefix>GB</gbprefix>
              <gbmandate>mandatory</gbmandate>
              <gbtopic>basic</gbtopic>
            </gbtype>
          </ext>
        </bibdata>
        <metanorma-extension>
          <semantic-metadata>
            <stage-published>false</stage-published>
          </semantic-metadata>
          <presentation-metadata>
            <document-scheme>2024</document-scheme>
            <toc-heading-levels>2</toc-heading-levels>
            <html-toc-heading-levels>2</html-toc-heading-levels>
            <doc-toc-heading-levels>3</doc-toc-heading-levels>
            <pdf-toc-heading-levels>3</pdf-toc-heading-levels>
          </presentation-metadata>
        </metanorma-extension>
        <boilerplate> </boilerplate>
        <sections>
          <terms id='_' obligation='normative'>
            <title id='_'>Terms and definitions</title>
            <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
            <p id='_'>
              ISO and IEC maintain terminology databases for use in standardization at
              the following addresses:
            </p>
            <ul id='_'>
              <li>
                <p id='_'>
                  ISO Online browsing platform: available at 
                  <link target='https://www.iso.org/obp'/>
                </p>
              </li>
              <li>
                <p id='_'>
                  IEC Electropedia: available at 
                  <link target='https://www.electropedia.org'/>
                </p>
              </li>
            </ul>
            <p id='_'>I am boilerplate</p>
            <ul id='_'>
              <li>
                <p id='_'>So am I</p>
              </li>
            </ul>
            <term id='_' anchor='term-Time'>
              <preferred language='zh'>
                <expression>
                  <name/>
                </expression>
              </preferred>
              <preferred language='en'>
                <expression>
                  <name>Time</name>
                </expression>
              </preferred>
              <definition id='_'>
                <verbal-definition id='_'>
                  <p id='_'>This paragraph is extraneous</p>
                </verbal-definition>
              </definition>
            </term>
          </terms>
        </sections>
      </metanorma>
    OUTPUT
  end

    it "does not strip any initial boilerplate from terms and definitions if keep-boilerplate attribute" do
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true))).to be_equivalent_to <<~"OUTPUT"

      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :keep-boilerplate:
      :language: en
      :script: Latn

      == Terms and Definitions

      I am boilerplate

      * So am I

      === Time

      This paragraph is extraneous
    INPUT
      <?xml version='1.0' encoding='UTF-8'?>
      <metanorma xmlns='https://www.metanorma.org/ns/standoc' type='semantic' version="#{Metanorma::Gb::VERSION}" schema-version='v2.3.0' flavor='gb'>
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
              <name>
                General Administration of Quality Supervision, Inspection and
                Quarantine; Standardization Administration of China
              </name>
            </organization>
          </contributor>
          <language>en</language>
          <script>Latn</script>
          <status>
            <stage>published</stage>
          </status>
          <copyright>
            <from>#{Date.today.year}</from>
            <owner>
              <organization>
                <name>
                  General Administration of Quality Supervision, Inspection and
                  Quarantine; Standardization Administration of China
                </name>
              </organization>
            </owner>
          </copyright>
          <ext>
            <doctype>standard</doctype>
            <structuredidentifier>
              <project-number/>
            </structuredidentifier>
            <stagename>International standard</stagename>
            <gbtype>
              <gbscope>national</gbscope>
              <gbprefix>GB</gbprefix>
              <gbmandate>mandatory</gbmandate>
              <gbtopic>basic</gbtopic>
            </gbtype>
          </ext>
        </bibdata>
        <metanorma-extension>
          <semantic-metadata>
            <stage-published>false</stage-published>
          </semantic-metadata>
          <presentation-metadata>
            <document-scheme>2024</document-scheme>
            <toc-heading-levels>2</toc-heading-levels>
            <html-toc-heading-levels>2</html-toc-heading-levels>
            <doc-toc-heading-levels>3</doc-toc-heading-levels>
            <pdf-toc-heading-levels>3</pdf-toc-heading-levels>
          </presentation-metadata>
        </metanorma-extension>
        <boilerplate> </boilerplate>
        <sections>
          <terms id='_' obligation='normative'>
            <title id='_'>Terms and definitions</title>
            <p id='_'>I am boilerplate</p>
            <ul id='_'>
              <li>
                <p id='_'>So am I</p>
              </li>
            </ul>
            <term id='_' anchor='term-Time'>
              <preferred language='zh'>
                <expression>
                  <name/>
                </expression>
              </preferred>
              <preferred language='en'>
                <expression>
                  <name>Time</name>
                </expression>
              </preferred>
              <definition id='_'>
                <verbal-definition id='_'>
                  <p id='_'>This paragraph is extraneous</p>
                </verbal-definition>
              </definition>
            </term>
          </terms>
        </sections>
      </metanorma>
    OUTPUT
  end

  it "processes ISO inline_quoted formatting" do
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)).sub(/\A<\?xml[^>]*\?>\s*/, "")).to be_equivalent_to <<~"OUTPUT"
      #{ASCIIDOC_BLANK_HDR}

      _emphasis_
      *strong*
      `monospace`
      "double quote"
      'single quote'
      super^script^
      sub~script~
      stem:[a_90]
      stem:[<mml:math><mml:msub xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"> <mml:mrow> <mml:mrow> <mml:mi mathvariant="bold-italic">F</mml:mi> </mml:mrow> </mml:mrow> <mml:mrow> <mml:mrow> <mml:mi mathvariant="bold-italic">&#x391;</mml:mi> </mml:mrow> </mml:mrow> </mml:msub> </mml:math>]
      [alt]#alt#
      [deprecated]#deprecated#
      [domain]#domain#
      [strike]#strike#
      [smallcap]#smallcap#
    INPUT
      <metanorma xmlns='https://www.metanorma.org/ns/standoc' type='semantic' version='1.5.9.pre.alpha.4' schema-version='v2.3.0' flavor='gb'>
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
              <name>
                General Administration of Quality Supervision, Inspection and
                Quarantine; Standardization Administration of China
              </name>
            </organization>
          </contributor>
          <language>en</language>
          <script>Latn</script>
          <status>
            <stage>published</stage>
          </status>
          <copyright>
            <from>2026</from>
            <owner>
              <organization>
                <name>
                  General Administration of Quality Supervision, Inspection and
                  Quarantine; Standardization Administration of China
                </name>
              </organization>
            </owner>
          </copyright>
          <ext>
            <doctype>standard</doctype>
            <structuredidentifier>
              <project-number/>
            </structuredidentifier>
            <stagename>International standard</stagename>
            <gbtype>
              <gbscope>national</gbscope>
              <gbprefix>GB</gbprefix>
              <gbmandate>mandatory</gbmandate>
              <gbtopic>basic</gbtopic>
            </gbtype>
          </ext>
        </bibdata>
        <metanorma-extension>
          <semantic-metadata>
            <stage-published>false</stage-published>
          </semantic-metadata>
          <presentation-metadata>
            <document-scheme>2024</document-scheme>
            <toc-heading-levels>2</toc-heading-levels>
            <html-toc-heading-levels>2</html-toc-heading-levels>
            <doc-toc-heading-levels>3</doc-toc-heading-levels>
            <pdf-toc-heading-levels>3</pdf-toc-heading-levels>
          </presentation-metadata>
        </metanorma-extension>
        <boilerplate> </boilerplate>
        <sections>
          <em>emphasis</em>
          <strong>strong</strong>
          <tt>monospace</tt>
           “double quote” ‘single quote’ super
          <sup>script</sup>
           sub
          <sub>script</sub>
          <stem block='false' type='MathML'>
            <math xmlns='http://www.w3.org/1998/Math/MathML'>
              <mstyle displaystyle='false'>
                <msub>
                  <mi>a</mi>
                  <mn>90</mn>
                </msub>
              </mstyle>
            </math>
            <asciimath>a_90</asciimath>
          </stem>
          <stem block='false' type='MathML'>
            <math xmlns='http://www.w3.org/1998/Math/MathML'>
              <msub>
                <mrow>
                  <mrow>
                    <mi mathvariant='bold-italic'>F</mi>
                  </mrow>
                </mrow>
                <mrow>
                  <mrow>
                    <mi mathvariant='bold-italic'>Α</mi>
                  </mrow>
                </mrow>
              </msub>
            </math>
          </stem>
          <admitted language='zh'>
            <expression>
              <name/>
            </expression>
          </admitted>
          <admitted language='en'>
            <expression>
              <name>alt</name>
            </expression>
          </admitted>
          <deprecates language='zh'>
            <expression>
              <name/>
            </expression>
          </deprecates>
          <deprecates language='en'>
            <expression>
              <name>deprecated</name>
            </expression>
          </deprecates>
          <domain>domain</domain>
          <strike>strike</strike>
          <smallcap>smallcap</smallcap>
        </sections>
      </metanorma>
    OUTPUT
  end

  it "processes GB inline_quoted formatting" do
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true))).to be_equivalent_to <<~"OUTPUT"

    #{ASCIIDOC_BLANK_HDR}

    [en]#en#
    [zh]#zh#
    [zh-Hans]#zh-Hans#
    [zh-Hant]#zh-Hant#
    INPUT
      <?xml version='1.0' encoding='UTF-8'?>
      <metanorma xmlns='https://www.metanorma.org/ns/standoc' type='semantic' version="#{Metanorma::Gb::VERSION}" schema-version='v2.3.0' flavor='gb'>
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
              <name>
                General Administration of Quality Supervision, Inspection and
                Quarantine; Standardization Administration of China
              </name>
            </organization>
          </contributor>
          <language>en</language>
          <script>Latn</script>
          <status>
            <stage>published</stage>
          </status>
          <copyright>
            <from>#{Date.today.year}</from>
            <owner>
              <organization>
                <name>
                  General Administration of Quality Supervision, Inspection and
                  Quarantine; Standardization Administration of China
                </name>
              </organization>
            </owner>
          </copyright>
          <ext>
            <doctype>standard</doctype>
            <structuredidentifier>
              <project-number/>
            </structuredidentifier>
            <stagename>International standard</stagename>
            <gbtype>
              <gbscope>national</gbscope>
              <gbprefix>GB</gbprefix>
              <gbmandate>mandatory</gbmandate>
              <gbtopic>basic</gbtopic>
            </gbtype>
          </ext>
        </bibdata>
        <metanorma-extension>
          <semantic-metadata>
            <stage-published>false</stage-published>
          </semantic-metadata>
          <presentation-metadata>
            <document-scheme>2024</document-scheme>
            <toc-heading-levels>2</toc-heading-levels>
            <html-toc-heading-levels>2</html-toc-heading-levels>
            <doc-toc-heading-levels>3</doc-toc-heading-levels>
            <pdf-toc-heading-levels>3</pdf-toc-heading-levels>
          </presentation-metadata>
        </metanorma-extension>
        <boilerplate> </boilerplate>
        <sections>
          <p id='_'>
            <string language='en'>en</string>
            <string language='zh'>zh</string>
            <string language='zh' script='Hans'>zh-Hans</string>
            <string language='zh' script='Hant'>zh-Hant</string>
          </p>
        </sections>
      </metanorma>
    OUTPUT
  end

  it "extracts localised strings by content" do
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true))).to be_equivalent_to <<~"OUTPUT"

    #{ASCIIDOC_BLANK_HDR}
    [deprecated]#deprecated 被取代#
    INPUT
      <?xml version='1.0' encoding='UTF-8'?>
      <metanorma xmlns='https://www.metanorma.org/ns/standoc' type='semantic' version="#{Metanorma::Gb::VERSION}" schema-version='v2.3.0' flavor='gb'>
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
              <name>
                General Administration of Quality Supervision, Inspection and
                Quarantine; Standardization Administration of China
              </name>
            </organization>
          </contributor>
          <language>en</language>
          <script>Latn</script>
          <status>
            <stage>published</stage>
          </status>
          <copyright>
            <from>#{Date.today.year}</from>
            <owner>
              <organization>
                <name>
                  General Administration of Quality Supervision, Inspection and
                  Quarantine; Standardization Administration of China
                </name>
              </organization>
            </owner>
          </copyright>
          <ext>
            <doctype>standard</doctype>
            <structuredidentifier>
              <project-number/>
            </structuredidentifier>
            <stagename>International standard</stagename>
            <gbtype>
              <gbscope>national</gbscope>
              <gbprefix>GB</gbprefix>
              <gbmandate>mandatory</gbmandate>
              <gbtopic>basic</gbtopic>
            </gbtype>
          </ext>
        </bibdata>
        <metanorma-extension>
          <semantic-metadata>
            <stage-published>false</stage-published>
          </semantic-metadata>
          <presentation-metadata>
            <document-scheme>2024</document-scheme>
            <toc-heading-levels>2</toc-heading-levels>
            <html-toc-heading-levels>2</html-toc-heading-levels>
            <doc-toc-heading-levels>3</doc-toc-heading-levels>
            <pdf-toc-heading-levels>3</pdf-toc-heading-levels>
          </presentation-metadata>
        </metanorma-extension>
        <boilerplate> </boilerplate>
        <sections>
          <deprecates language='zh'>
            <expression>
              <name>被取代</name>
            </expression>
          </deprecates>
          <deprecates language='en'>
            <expression>
              <name>deprecated</name>
            </expression>
          </deprecates>
        </sections>
      </metanorma>
    OUTPUT
  end

  it "extracts tagged localised strings" do
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true))).to be_equivalent_to <<~"OUTPUT"

      #{ASCIIDOC_BLANK_HDR}
      [bibliography]
      == Bibliography

      * [[[xiso123,XISO 123]]] _a_ [zh]#A# [en]#B#
    INPUT
       <?xml version='1.0' encoding='UTF-8'?>
       <metanorma xmlns='https://www.metanorma.org/ns/standoc' type='semantic' version="#{Metanorma::Gb::VERSION}" schema-version='v2.3.0' flavor='gb'>
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
               <name>
                 General Administration of Quality Supervision, Inspection and
                 Quarantine; Standardization Administration of China
               </name>
             </organization>
           </contributor>
           <language>en</language>
           <script>Latn</script>
           <status>
             <stage>published</stage>
           </status>
           <copyright>
             <from>#{Date.today.year}</from>
             <owner>
               <organization>
                 <name>
                   General Administration of Quality Supervision, Inspection and
                   Quarantine; Standardization Administration of China
                 </name>
               </organization>
             </owner>
           </copyright>
           <ext>
             <doctype>standard</doctype>
             <structuredidentifier>
               <project-number/>
             </structuredidentifier>
             <stagename>International standard</stagename>
             <gbtype>
               <gbscope>national</gbscope>
               <gbprefix>GB</gbprefix>
               <gbmandate>mandatory</gbmandate>
               <gbtopic>basic</gbtopic>
             </gbtype>
           </ext>
         </bibdata>
         <metanorma-extension>
           <semantic-metadata>
             <stage-published>false</stage-published>
           </semantic-metadata>
           <presentation-metadata>
             <document-scheme>2024</document-scheme>
             <toc-heading-levels>2</toc-heading-levels>
             <html-toc-heading-levels>2</html-toc-heading-levels>
             <doc-toc-heading-levels>3</doc-toc-heading-levels>
             <pdf-toc-heading-levels>3</pdf-toc-heading-levels>
           </presentation-metadata>
         </metanorma-extension>
         <boilerplate> </boilerplate>
         <sections> </sections>
         <bibliography>
           <references id='_' normative='false' obligation='informative'>
             <title id='_'>Bibliography</title>
             <bibitem anchor='xiso123' id='_'>
               <em>a</em>
               <formattedref language='zh'>A</formattedref>
               <formattedref language='en'>B</formattedref>
               <docidentifier>XISO 123</docidentifier>
               <docnumber>123</docnumber>
               <language>en</language>
               <script>Latn</script>
             </bibitem>
           </references>
         </bibliography>
       </metanorma>
    OUTPUT
  end

    it "fetches simple GB reference in English" do
    mock_gbbib_get_123("en")
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true))).to be_equivalent_to <<~"OUTPUT"

      #{ISOBIB_BLANK_HDR}
      
      <<iso123>>

      [bibliography]
      == Normative References

      * [[[iso123,GB/T 20223-2006]]] _Standard_
    INPUT
      <?xml version='1.0' encoding='UTF-8'?>
      <metanorma xmlns='https://www.metanorma.org/ns/standoc' type='semantic' version='1.5.9.pre.alpha.4' schema-version='v2.3.0' flavor='gb'>
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
              <name>
                General Administration of Quality Supervision, Inspection and
                Quarantine; Standardization Administration of China
              </name>
            </organization>
          </contributor>
          <language>en</language>
          <script>Latn</script>
          <status>
            <stage>published</stage>
          </status>
          <copyright>
            <from>#{Date.today.year}</from>
            <owner>
              <organization>
                <name>
                  General Administration of Quality Supervision, Inspection and
                  Quarantine; Standardization Administration of China
                </name>
              </organization>
            </owner>
          </copyright>
          <ext>
            <doctype>standard</doctype>
            <structuredidentifier>
              <project-number/>
            </structuredidentifier>
            <stagename>International standard</stagename>
            <gbtype>
              <gbscope>national</gbscope>
              <gbprefix>GB</gbprefix>
              <gbmandate>mandatory</gbmandate>
              <gbtopic>basic</gbtopic>
            </gbtype>
          </ext>
        </bibdata>
        <metanorma-extension>
          <semantic-metadata>
            <stage-published>false</stage-published>
          </semantic-metadata>
          <presentation-metadata>
            <document-scheme>2024</document-scheme>
            <toc-heading-levels>2</toc-heading-levels>
            <html-toc-heading-levels>2</html-toc-heading-levels>
            <doc-toc-heading-levels>3</doc-toc-heading-levels>
            <pdf-toc-heading-levels>3</pdf-toc-heading-levels>
          </presentation-metadata>
        </metanorma-extension>
        <boilerplate> </boilerplate>
        <preface>
          <foreword id='_' obligation='informative'>
            <title id='_'>Foreword</title>
            <p id='_'>
              <eref type='inline' bibitemid='iso123' citeas='GB/T 20223'/>
            </p>
          </foreword>
        </preface>
        <sections> </sections>
        <bibliography>
          <references id='_' normative='true' obligation='informative'>
            <title id='_'>Normative references</title>
            <p id='_'>
              The following documents are referred to in the text in such a way that
              some or all of their content constitutes requirements of this document.
              For dated references, only the edition cited applies. For undated
              references, the latest edition of the referenced document (including any
              amendments) applies.
            </p>
            <bibitem id='_' type='standard' schema-version='v1.5.6' anchor='iso123'>
              <fetched>#{Date.today}</fetched>
              <title format='text/plain' language='zh' script='Hans'>棉短绒</title>
              <title format='text/plain' language='en' script='Latn'>Cotton linter</title>
              <uri type='src'>http://www.std.gov.cn/gb/search/gbDetailed?id=5DDA8BA00FC618DEE05397BE0A0A95A7</uri>
              <docidentifier type='GB'>GB/T 20223</docidentifier>
              <date type='published'>
                <on>2006</on>
              </date>
              <contributor>
                <role type='publisher'/>
                <organization>
                  <name>GB/T</name>
                  <abbreviation>GB/T</abbreviation>
                </organization>
              </contributor>
              <language>zh</language>
              <script>Hans</script>
              <status>
                <stage>obsoleted</stage>
              </status>
            </bibitem>
          </references>
        </bibliography>
      </metanorma>
    OUTPUT
    end

     it "fetches simple GB reference in Chinese" do
    mock_gbbib_get_123("zh")
    expect(strip_guid(Asciidoctor.convert(<<~"INPUT", backend: :gb, header_footer: true)).sub(%r{<bibdata.*</bibdata>}m, "")).to be_equivalent_to <<~"OUTPUT"

      #{ISOBIB_BLANK_HDR_ZH}

      <<iso123>>

      [bibliography]
      == Normative References

      * [[[iso123,GB/T 20223-2006]]] _Standard_
    INPUT
      <?xml version='1.0' encoding='UTF-8'?>
      <metanorma xmlns='https://www.metanorma.org/ns/standoc' type='semantic' version='1.5.9.pre.alpha.4' schema-version='v2.3.0' flavor='gb'>
        <metanorma-extension>
          <semantic-metadata>
            <stage-published>false</stage-published>
          </semantic-metadata>
          <presentation-metadata>
            <document-scheme>2024</document-scheme>
            <toc-heading-levels>2</toc-heading-levels>
            <html-toc-heading-levels>2</html-toc-heading-levels>
            <doc-toc-heading-levels>3</doc-toc-heading-levels>
            <pdf-toc-heading-levels>3</pdf-toc-heading-levels>
          </presentation-metadata>
        </metanorma-extension>
        <boilerplate> </boilerplate>
        <preface>
          <foreword id='_' obligation='informative'>
            <title id='_'>前言</title>
            <p id='_'>
              <eref type='inline' bibitemid='iso123' citeas='GB/T 20223'/>
            </p>
          </foreword>
        </preface>
        <sections> </sections>
        <bibliography>
          <references id='_' normative='true' obligation='informative'>
            <title id='_'>规范性引用文件</title>
            <p id='_'>下列文件对于本文件的应用是必不可少的。凡是注日期的引用文件，仅注日期的版本适用于本文件。凡是不注日期的引用文件，其最新版本（包括所有的修改单）适用于本文件。</p>
            <bibitem id='_' type='standard' schema-version='v1.5.6' anchor='iso123'>
              <fetched>#{Date.today}</fetched>
              <title format='text/plain' language='zh' script='Hans'>棉短绒</title>
              <title format='text/plain' language='en' script='Latn'>Cotton linter</title>
              <uri type='src'>http://www.std.gov.cn/gb/search/gbDetailed?id=5DDA8BA00FC618DEE05397BE0A0A95A7</uri>
              <docidentifier type='GB'>GB/T 20223</docidentifier>
              <date type='published'>
                <on>2006</on>
              </date>
              <contributor>
                <role type='publisher'/>
                <organization>
                  <name>GB/T</name>
                  <abbreviation>GB/T</abbreviation>
                </organization>
              </contributor>
              <language>zh</language>
              <script>Hans</script>
              <status>
                <stage>obsoleted</stage>
              </status>
            </bibitem>
          </references>
        </bibliography>
      </metanorma>
    OUTPUT
    end


    private

    def mock_gbbib_get_123(lang)
      expect(Relaton::Gb::Bibliography).to receive(:get).with(anything, anything, anything) do
        Relaton::Gb::Item.from_xml(GBT20223)
      end
    end
end
