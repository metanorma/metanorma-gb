module Asciidoctor
  module Gb

    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class Converter < ISO::Converter

      def bibliography_parse(attrs, xml, node)
        @biblio = true
        xml.references **attr_code(attrs) do |xml_section|
          title = node.level == 1 ? "参考文献" : node.title
          xml_section.title { |t| t << title }
          xml_section << node.content
        end
        @biblio = true
      end

      def term_def_parse(attrs, xml, node, title)
        @term_def = true
        xml.terms **attr_code(attrs) do |xml_section|
          if title == "terms, definitions, symbols and abbreviations" # TODO: Chinese
            title = "Terms, Definitions, Symbols and Abbreviations" # TODO: Chinese
          else
            title = "术语和定义"
          end
          xml_section.title { |t| t << title }
          xml_section << node.content
        end
        @term_def = false
      end

      def norm_ref_parse(attrs, xml, node)
        @norm_ref = true
        xml.references **attr_code(attrs) do |xml_section|
          xml_section.title { |t| t << "规范性引用文件" }
          xml_section << node.content
        end
        @norm_ref = false
      end

      def introduction_parse(attrs, xml, node)
        xml.introduction **attr_code(attrs) do |xml_section|
          xml_section.title = "引言"
          content = node.content
          xml_section << content
          introduction_style(node,
                             ISO::Utils::flatten_rawtext(content).
                             join("\n"))
        end
      end

      def scope_parse(attrs, xml, node)
        @scope = true
        xml.clause **attr_code(attrs) do |xml_section|
          xml_section.title { |t| t << "范围" }
          content = node.content
          xml_section << content
          c = ISO::Utils::flatten_rawtext(content).join("\n")
          scope_style(node, c)
        end
        @scope = false
      end


      def section(node)
        a = { id: Asciidoctor::ISO::Utils::anchor_or_uuid(node) }
        noko do |xml|
          case node.title.downcase
          when "引言" then
            if node.level == 1
              introduction_parse(a, xml, node)
            else
              clause_parse(a, xml, node)
            end
          when "patent notice" then patent_notice_parse(xml, node)
          when "范围", "scope" then scope_parse(a, xml, node)
          when "规范性引用文件", "normative references"
          norm_ref_parse(a, xml, node)
          when "术语和定义", "terms and definitions"
            term_def_parse(a, xml, node, node.title.downcase)
          when "符号、代号和缩略语", "symbols and abbreviated terms"
            symbols_parse(a, xml, node)
          when "参考文献", "bibliography" then bibliography_parse(a, xml, node)
          else
            if @term_def
              term_def_subclause_parse(a, xml, node)
            elsif @biblio
              bibliography_parse(a, xml, node)
            elsif node.attr("style") == "appendix" && node.level == 1
              annex_parse(a, xml, node)
            else
              clause_parse(a, xml, node)
            end
          end
        end.join("\n")
      end

      def preamble(node)
        noko do |xml|
          xml.foreword do |xml_abstract|
            xml_abstract.title { |t| t << "前言" }
            content = node.content
            xml_abstract << content
            text = Asciidoctor::ISO::Utils::flatten_rawtext(content).join("\n")
            foreword_style(node, text)
          end
        end.join("\n")
      end
      
    def normref_cleanup(xmldoc)
        q = "//references[title = '规范性引用文件']"
        r = xmldoc.at(q)
        r.elements.each do |n|
          n.remove unless ["title", "bibitem"].include? n.name
        end
      end

      def normref_validate(root)
        f = root.at("//references[title = '规范性引用文件']")
        f.at("./references") and
          warn "ISO style: normative references contains subsections"
      end

      def symbols_validate(root)
        f = root.at("//clause[title = '符号、代号和缩略语']")
        return if f.nil?
        f.elements do |e|
          unless e.name == "dl"
            warn "ISO style: Symbols and Abbreviations can only contain "\
              "a definition list"
            return
          end
        end
      end


      # spec of permissible section sequence
      SEQ = [
        {
          msg: "Initial section must be (content) Foreword",
          val:  [{ tag: "foreword", title: "前言" }],
        },
        {
          msg: "Prefatory material must be followed by (clause) Scope",
          val:  [{ tag: "introduction", title: "引言" },
                 { tag: "clause", title: "范围" }],
        },
        {
          msg: "Prefatory material must be followed by (clause) Scope",
          val: [{ tag: "clause", title: "范围" }],
        },
        # we skip normative references, it goes to end of list
        #{
        #msg: "Scope must be followed by Normative References",
        #val: [{ tag: "references", title: "Normative References" }]
        #},
        {
          msg: "Normative References must be followed by "\
          "Terms and Definitions",
          val: [
            { tag: "terms", title: "术语和定义" },
            { tag: "terms",
              title: "Terms, Definitions, Symbols and Abbreviations" } # TODO: Chinese
          ]
        },
      ]

      def sections_sequence_validate(root)
        f = root.xpath(" //foreword | //introduction | //sections/terms | "\
                       "//sections/clause | ./references | "\
                       "./annex")
        names = f.map { |s| { tag: s.name, title: s.at("./title").text } }
        names = seqcheck(names, SEQ[0][:msg], SEQ[0][:val]) or return
        n = names[0]
        names = seqcheck(names, SEQ[1][:msg], SEQ[1][:val]) or return
        if n == { tag: "introduction", title: "引言" }
          names = seqcheck(names, SEQ[2][:msg], SEQ[2][:val]) or return
        end
        # names = seqcheck(names, SEQ[3][:msg], SEQ[3][:val]) or return
        names = seqcheck(names, SEQ[3][:msg], SEQ[3][:val]) or return
        n = names.shift
        if n == { tag: "clause", title: "符号、代号和缩略语" }
          n = names.shift or return
        end
        n[:tag] == "clause" or
          warn "ISO style: Document must contain at least one clause"
        n == { tag: "clause", title: "Scope" } and
          warn "ISO style: Scope must occur before Terms and Definitions"
        n = names.shift or return
        while n[:tag] == "clause"
          n[:title] == "范围" and
            warn "ISO style: Scope must occur before Terms and Definitions"
          n[:title] == "符号、代号和缩略语" and
            warn "ISO style: Symbols and Abbreviations must occur "\
            "right after Terms and Definitions"
          n = names.shift or return
        end
        unless n[:tag] == "annex" or n[:tag] == "references"
          warn "ISO style: Only annexes and references can follow clauses"
        end
        while n[:tag] == "annex"
          n = names.shift or return
        end
        n == { tag: "references", title: "规范性引用文件" } or
          warn "ISO style: Document must include (references) Normative References"
        n = names.shift
        n == { tag: "references", title: "参考文献" } or
          warn "ISO style: Final section must be (references) Bibliography"
        names.empty? or
          warn "ISO style: There are sections after the final Bibliography"
      end
    end
  end
end
