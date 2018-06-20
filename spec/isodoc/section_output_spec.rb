require "spec_helper"

RSpec.describe IsoDoc::Gb::HtmlConvert do
  it "processes empty terms & definitions" do
          expect(IsoDoc::Gb::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(/^.*<body/m, "<body").gsub(%r{</body>.*}m, "</body>")).to be_equivalent_to <<~"OUTPUT"
        <gb-standard xmlns="http://riboseinc.com/gbstandard">
        <bibdata>
        <language>zh</language>
        <script>Hans</script>
        </bibdata>
               <sections>
       <terms id="H" obligation="normative"><title>Terms, Definitions, Symbols and Abbreviated Terms</title>
       </terms>
        </sections>
    </gb-standard>
    INPUT
      #{HTML_HDR}
               <p class="zzSTDTitle1">XXXX</p>
       <div id="H"><h1>1.&#12288;&#26415;&#35821;&#21644;&#23450;&#20041;</h1><p>&#26412;&#25991;&#20214;&#19981;&#25552;&#20379;&#26415;&#35821;&#21644;&#23450;&#20041;&#12290;</p>
              <p>ISO&#21644;IEC&#29992;&#20110;&#26631;&#20934;&#21270;&#30340;&#26415;&#35821;&#25968;&#25454;&#24211;&#22320;&#22336;&#22914;&#19979;&#65306;</p>
       <ul>
       <li> <p>ISO&#22312;&#32447;&#27983;&#35272;&#24179;&#21488;:
         &#20301;&#20110;<a href="http://www.iso.org/obp">http://www.iso.org/obp</a></p> </li>
       <li> <p>IEC Electropedia:
         &#20301;&#20110;<a href="http://www.electropedia.org">http://www.electropedia.org</a>
       </p> </li> </ul>
       </div>
               <hr width="25%"/>
             </div>
           </body>
    OUTPUT
  end

    it "processes clause names" do
          expect(IsoDoc::Gb::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(/^.*<body/m, "<body").gsub(%r{</body>.*}m, "</body>")).to be_equivalent_to <<~"OUTPUT"
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
    #{HTML_HDR}
               <p class="zzSTDTitle1">XXXX</p>
                     <div id="M">
        <h1>1.&#12288;Clause 4</h1>
        <div id="N">
   <h2>1.1.&#12288;Introduction</h2>
 </div>
        <div id="O">
   <span class="zzMoveToFollowing"><b>1.2. Clause 4.2 </b></span>
 </div>
      </div>
               <hr width="25%"/>
             </div>
           </body>
    OUTPUT
  end

        it "processes annex names" do
          expect(IsoDoc::Gb::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(/^.*<body/m, "<body").gsub(%r{</body>.*}m, "</body>")).to be_equivalent_to <<~"OUTPUT"
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
    #{HTML_HDR}
               <p class="zzSTDTitle1">XXXX</p>
               <br/>
               <div id="P" class="Section3">
                 <h1 class="Annex"><b>Annex A</b><br/>(normative)<br/><br/>Annex</h1>
               </div>
               <hr width="25%"/>
             </div>
           </body>
    OUTPUT
  end

end
