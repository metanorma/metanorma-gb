require "spec_helper"

RSpec.describe Asciidoctor::Gb::GbConvert do
  it "cleans up formulas" do
    expect(Asciidoctor::Gb::GbConvert.new({}).cleanup(Nokogiri::XML(<<~"INPUT")).to_s).to be_equivalent_to <<~"OUTPUT"
    <html>
    <body>
      <table class="dl">
        <p>Text</p>
      </div>
    </body>
    </html>
    INPUT
           <?xml version="1.0"?>
       <html>
       <body>
         <table class="dl">
           <p class="dl">Text</p>
         </table>
       </body>
       </html>
    OUTPUT
  end

  it "cleans up examples" do
    expect(Asciidoctor::Gb::GbConvert.new({}).cleanup(Nokogiri::XML(<<~"INPUT")).to_s).to be_equivalent_to <<~"OUTPUT"
    <html>
    <body>
      <table class="Note">
        <p>Text</p>
      </div>
    </body>
    </html>
    INPUT
           <?xml version="1.0"?>
       <html>
       <body>
         <table class="Note">
           <p class="Note">Text</p>
         </table>
       </body>
       </html>
    OUTPUT
  end

  it "cleans up titles" do
    gbc = Asciidoctor::Gb::GbConvert.new({})
    docxml, filename, dir = gbc.convert_init(<<~"INPUT", "test", true)
    <gb-standard xmlns="http://riboseinc.com/gbstandard">
<bibdata>
<script>Hans</script>
</bibdata>
</gb-standard>
    INPUT
    expect(gbc.cleanup(Nokogiri::XML(<<~"INPUT")).to_s).to be_equivalent_to <<~"OUTPUT"
    <html>
    <body>
        <p class="zzContents">Text</p>
        <p class="ForewordTitle">Text</p>
        <p class="IntroTitle">Text</p>
        <h1 class="Annex">Text<br/>Text2</h1>
    </body>
    </html>
    INPUT
           <?xml version="1.0"?>
       <html>
       <body>
                  <p class="zzContents">T&#xA0;&#xA0;e&#xA0;&#xA0;x&#xA0;&#xA0;t</p>
           <p class="ForewordTitle">T&#xA0;&#xA0;e&#xA0;&#xA0;x&#xA0;&#xA0;t</p>
           <p class="IntroTitle">T&#xA0;&#xA0;e&#xA0;&#xA0;x&#xA0;&#xA0;t</p>
           <h1 class="Annex">T&#xA0;&#xA0;e&#xA0;&#xA0;x&#xA0;&#xA0;t<br/>Text2</h1>
       </body>
       </html>
    OUTPUT
  end

  it "cleans up terms" do
    gbc = Asciidoctor::Gb::GbConvert.new()
    docxml, filename, dir = gbc.convert_init(<<~"INPUT", "test", true)
    <gb-standard xmlns="http://riboseinc.com/gbstandard">
<bibdata>
<language>en</language>
<script>Latn</script>
</bibdata>
</gb-standard>
    INPUT
    expect(gbc.cleanup(Nokogiri::XML(<<~"INPUT")).to_s).to be_equivalent_to <<~"OUTPUT"
    <html>
    <body>
        <p class="Terms" lang="zh">Text</p>
        <p class="Terms" lang="en">Text2</p>
        <p class="AltTerms" lang="zh">Text</p>
        <p class="AltTerms" lang="en">Text2</p>
        <p class="DeprecatedTerms" lang="zh">DEPRECATED: Text</p>
        <p class="DeprecatedTerms" lang="en">DEPRECATED: Text2</p>
    </body>
    </html>
    INPUT
           <?xml version="1.0"?>
       <html>
       <body>
           <p class="Terms" lang="zh">Text&#x3000;Text2</p>
           <p class="AltTerms" lang="zh">Text&#x3000;Text2</p>
           <p class="DeprecatedTerms" lang="zh">DEPRECATED: Text&#x3000;Text2</p>
       </body>
       </html>
    OUTPUT
  end

end
