require "spec_helper"

require "metanorma"
require "fileutils"

RSpec.describe Metanorma::Gb::Processor do

  registry = Metanorma::Registry.instance
  registry.register(Metanorma::Gb::Processor)
  processor = registry.find_processor(:gb)

  it "registers against metanorma" do
    expect(processor).not_to be nil
  end

  it "registers output formats against metanorma" do
    expect(processor.output_formats.sort.to_s).to be_xml_equivalent_to <<~"OUTPUT"
[[:compliant_html, "compliant.html"], [:doc, "doc"], [:html, "html"], [:pdf, "pdf"], [:presentation, "presentation.xml"], [:rxl, "rxl"], [:xml, "xml"]]
    OUTPUT
  end

  it "registers version against metanorma" do
    expect(processor.version.to_s).to match(%r{^Metanorma::Gb })
  end

  it "generates IsoDoc XML from a blank document" do
    expect(processor.input_to_isodoc(<<~"INPUT", nil)).to be_xml_equivalent_to <<~"OUTPUT"

    #{ASCIIDOC_BLANK_HDR}
    INPUT
<?xml version="1.0" encoding="UTF-8"?>
<metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="1.5.9.pre.alpha.4" schema-version="v2.3.0" flavor="gb">
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
  
</boilerplate><sections> </sections>
</metanorma>
    OUTPUT
  end

  it "generates HTML from IsoDoc XML" do
    FileUtils.rm_f "text.xml"
    processor.output(<<~"INPUT", "test.xml", "test.html", :html)
        <gb-standard xmlns="http://riboseinc.com/isoxml">
               <bibdata> <language>en</language> <script>Latn</script> </bibdata>
       <sections>
       <terms id="H" obligation="normative"><title>1.<tab/>Terms, Definitions, Symbols and Abbreviated Terms</title>
         <term id="J">
         <name>1.1.</name>
         <preferred>Term2</preferred>
       </term>
        </terms>
        </sections>
        </gb-standard>
    INPUT
    expect(File.read("test.html", encoding: "utf-8").gsub(%r{^.*<main}m, "<main").gsub(%r{</main>.*}m, "</main>")).to be_xml_equivalent_to <<~"OUTPUT"
<main class="main-section"></main>
    OUTPUT
  end

end
