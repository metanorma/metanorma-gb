require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "bundler/setup"
require "asciidoctor"
require "asciidoctor/gb"
require "metanorma-gb"
require "rspec/matchers"
require "equivalent-xml"
require "htmlentities"
require "metanorma"
require "metanorma/gb"
require "rexml/document"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def strip_guid(x)
  x.gsub(%r{ id="_[^"]+"}, ' id="_"').gsub(%r{ target="_[^"]+"}, ' target="_"')
end

def htmlencode(x)
  HTMLEntities.new.encode(x, :hexadecimal).gsub(/&#x3e;/, ">").gsub(/&#xa;/, "\n").
    gsub(/&#x22;/, '"').gsub(/&#x3c;/, "<").gsub(/&#x26;/, '&').gsub(/&#x27;/, "'").
    gsub(/\\u(....)/) { |s| "&#x#{$1.downcase};" }.gsub(/, :/, ",\n:")
end

def xmlpp(x)
  s = ""
  f = REXML::Formatters::Pretty.new(2)
  f.compact = true
  f.write(REXML::Document.new(x),s)
  s
end

ASCIIDOC_BLANK_HDR = <<~"HDR"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :language: en
      :script: Latn

HDR

ISOBIB_BLANK_HDR = <<~"HDR"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :no-isobib-cache:
      :language: en
      :script: Latn

HDR

VALIDATING_BLANK_HDR = <<~"HDR"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:

HDR

BOILERPLATE = <<~"END"
<boilerplate> </boilerplate>
END

BLANK_HDR = <<~"HDR"
       <?xml version="1.0" encoding="UTF-8"?>
       <gb-standard xmlns="https://www.metanorma.org/ns/gb">
       <bibdata type="standard">
         <contributor>
           <role type="author"/>
           <person>
             <name>
               <surname>Author</surname>
             </name>
           </person>
         </contributor>
         <contributor>
           <role type="author"/>
           <organization>
             <name>GB</name>
           </organization>
         </contributor>
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
             <name>General Administration of Quality Supervision, Inspection and Quarantine; Standardization Administration of China</name>
           </organization>
         </contributor>
         <language>en</language>
         <script>Latn</script>
         <status>
           <stage abbreviation="IS">60</stage>
           <substage>60</substage>
         </status>
         <copyright>
           <from>#{Date.today.year}</from>
           <owner>
             <organization>
               <name>General Administration of Quality Supervision, Inspection and Quarantine; Standardization Administration of China</name>
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
       #{BOILERPLATE}
HDR

HTML_HDR = <<~HDR
         <body lang="en">
           <div class="title-section">
             <p>&#160;</p>
           </div>
           <br/>
           <div class="prefatory-section">
             <p>&#160;</p>
           </div>
           <br/>
           <div class="main-section">
HDR

HTML_HDR_ZH = <<~HDR
         <body lang="zh">
           <div class="title-section">
             <p>&#160;</p>
           </div>
           <br/>
           <div class="prefatory-section">
             <p>&#160;</p>
           </div>
           <br/>
           <div class="main-section">
HDR

GBT20223 = <<~OUTPUT
<bibitem type="standard" id="GB/T20223">
  <fetched>#{Date.today}</fetched>
  <title format="text/plain" language="zh" script="Hans">棉短绒</title>
  <title format="text/plain" language="en" script="Latn">Cotton linter</title>
  <uri type="src">http://www.std.gov.cn/gb/search/gbDetailed?id=5DDA8BA00FC618DEE05397BE0A0A95A7</uri>
  <docidentifier type="GB">GB/T 20223</docidentifier>
  <date type="published">
    <on>2006</on>
  </date>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>GB/T</name>
      <abbreviation>GB/T</abbreviation>
    </organization>
  </contributor>
  <language>zh</language>
  <script>Hans</script>
  <status><stage>obsoleted</stage></status>
</bibitem>
      OUTPUT
