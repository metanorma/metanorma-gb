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
    expect(processor.output_formats.sort.to_s).to be_equivalent_to <<~"OUTPUT"
    [[:compliant_html, "compliant.html"], [:doc, "doc"], [:html, "html"], [:pdf, "pdf"], [:rxl, "rxl"], [:xml, "xml"]]
    OUTPUT
  end

  it "registers version against metanorma" do
    expect(processor.version.to_s).to match(%r{^Metanorma::Gb })
  end

  it "generates IsoDoc XML from a blank document" do
    expect(xmlpp(processor.input_to_isodoc(<<~"INPUT", nil))).to be_equivalent_to xmlpp(<<~"OUTPUT")
    #{ASCIIDOC_BLANK_HDR}
    INPUT
    #{BLANK_HDR}
<sections/>
</gb-standard>
    OUTPUT
  end

  it "generates HTML from IsoDoc XML" do
    FileUtils.rm_f "text.xml"
    processor.output(<<~"INPUT", "test.html", :html)
        <gb-standard xmlns="http://riboseinc.com/isoxml">
               <bibdata> <language>en</language> <script>Latn</script> </bibdata>
       <sections>
       <terms id="H" obligation="normative"><title>Terms, Definitions, Symbols and Abbreviated Terms</title>
         <term id="J">
         <preferred>Term2</preferred>
       </term>
        </terms>
        </sections>
        </gb-standard>
    INPUT
    expect(xmlpp(File.read("test.html", encoding: "utf-8").gsub(%r{^.*<main}m, "<main").gsub(%r{</main>.*}m, "</main>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
           <main class="main-section"><button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>
             <p class="zzSTDTitle1">XXXX</p>
             <div id="H"><h1 id="toc0">1.&#x3000;Terms, Definitions, Symbols and Abbreviated Terms</h1>
       <h2 class="TermNum" id="J">1.1.</h2>
         <p class="Terms" style="text-align:left;">Term2</p>
       </div>
             <hr width="25%" />
           </main>
    OUTPUT
  end

end
