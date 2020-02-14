
module Asciidoctor
  module Gb
    class Converter < ISO::Converter
      def doctype(node)
        type = node.attr("mandate") || "mandatory"
        type = "standard" if type == "mandatory"
        type = "recommendation" if type == "recommended"
        type
      end

      def metadata_author_personal(node, xml)
        author = node.attr("author") || return
        author.split(/, ?/).each do |author|
          xml.contributor do |c|
            c.role **{ type: "author" }
            c.person do |p|
              p.name do |n|
                n.surname author
              end
            end
          end
        end
      end

      def metadata_contributor1(node, xml, type, role)
        contrib = node.attr(type) || "GB"
        contrib.split(/, ?/).each do |c|
          xml.contributor do |x|
            x.role **{ type: role }
            x.organization do |a|
              a.name { |n| n << c }
            end
          end
        end
      end

      def metadata_copyright(node, xml)
        from = node.attr("copyright-year") || Date.today.year
        xml.copyright do |c|
          c.from from
          c.owner do |owner|
            owner.organization do |o|
              o.name "GB"
            end
          end
        end
      end

      def metadata_committee(node, xml)
        return unless node.attr("technical-committee")
        attrs = { type: node.attr("technical-committee-type") }
        xml.gbcommittee **attr_code(attrs) do |a|
          a << node.attr("technical-committee")
        end
        i = 2
        while node.attr("technical-committee_#{i}") do
          attrs = { type: node.attr("technical-committee-type_#{i}") }
          xml.gbcommittee **attr_code(attrs) do |a|
            a << node.attr("technical-committee_#{i}")
          end
          i += 1
        end
      end

      def metadata_equivalence(node, xml)
        isostd = node.attr("iso-standard") || return
        type = node.attr("equivalence") || "equivalent"
        m = /^(?<code>[^,]+),?(?<title>.*)$/.match isostd
        title = m[:title].empty? ? "[not supplied]" : m[:title]
        xml.relation **{ type: type } do |r|
          r.bibitem do |b|
            b.title { |t| t << title }
            b.docidentifier m[:code]
          end
        end
      end

      def metadata_relations(node, xml)
        metadata_equivalence(node, xml)
        metadata_obsoletes(node, xml)
      end

      def metadata_obsoletes(node, xml)
        std = node.attr("obsoletes") || return
        m = /^(?<code>[^,]+),?(?<title>.*)$/.match std
        title = m[:title].empty? ? "[not supplied]" : m[:title]
        xml.relation **{ type: "obsoletes" } do |r|
          r.bibitem do |b|
            b.title { |t| t << title }
            b.docidentifier m[:code]
          end
          r.bpart node.attr("obsoletes-parts") if node.attr("obsoletes-parts")
        end
      end

      def get_scope(node)
        node.attr("scope") and return node.attr("scope")
        scope = if %r{^[TQ]/}.match node.attr("prefix")
                  m = node.attr("prefix").split(%{/})
                  mandate = m[0] == "T" ? "social-group" :
                    m[0] == "Q" ? "enterprise" : nil
                end
        return scope unless scope.nil?
        warn "GB: no scope supplied, defaulting to National"
        "national"
      end

      def get_prefix(node)
        scope = get_scope(node)
        if prefix = node.attr("prefix")
          prefix.gsub!(%r{/[TZ]$}, "")
          prefix.gsub!(%r{^[TQ]/([TZ]/)?}, "")
          prefix.gsub!(/^DB/, "") if scope == "local"
        else
          prefix = "GB"
          scope = "national"
          warn "GB: no prefix supplied, defaulting to GB"
        end
        [scope, prefix]
      end

      def get_mandate(node)
        node.attr("mandate") and return node.attr("mandate")
        p = node.attr("prefix")
        mandate = %r{/T}.match(p) ? "recommended" :
          %r{/Z}.match(p) ? "guidelines" : nil
        if mandate.nil?
          mandate = "mandatory"
          warn "GB: no mandate supplied, defaulting to mandatory"
        end
        mandate
      end

      def get_topic(node)
        node.attr("topic") and return node.attr("topic")
        warn "GB: no topic supplied, defaulting to basic"
        "basic"
      end

      def metadata_gbtype(node, xml)
        xml.gbtype do |t|
          scope, prefix = get_prefix(node)
          t.gbscope { |s| s << scope }
          t.gbprefix { |p| p << prefix }
          t.gbmandate { |m| m << get_mandate(node) }
          t.gbtopic { |t| t << get_topic(node) }
        end
      end

      def metadata_gblibraryids(node, xml)
        ccs = node.attr("library-ccs")
        ccs and ccs.split(/, ?/).each do |l|
          xml.ccs { |c| c << l }
        end
        l = node.attr("library-plan")
        l && xml.plannumber { |plan| plan << l }
      end

      def metadata_author(node, xml)
        metadata_author_personal(node, xml)
        metadata_contributor1(node, xml, "author-committee", "author")
        i = 2
        while node.attr("author-committee_#{i}") do
          metadata_contributor1(node, xml, "author-committee_#{i}", "author")
          i += 1
        end
      end

      def metadata_publisher(node, xml)
        metadata_contributor1(node, xml, "publisher", "publisher")
        metadata_contributor1(node, xml, "authority", "authority")
        metadata_contributor1(node, xml, "proposer", "proposer")
        metadata_contributor1(node, xml, "issuer", "issuer")
      end

      def iso_id(node, xml)
        return unless node.attr("docnumber")
        part = node.attr("partnumber")
        dn = add_id_parts(node.attr("docnumber"), part, nil)
        dn = id_stage_prefix(dn, node)
        xml.docidentifier dn, **attr_code(type: "gb")
      end

      def structured_id(node, xml)
        part = node.attr("partnumber")
        xml.structuredidentifier do |i|
          i.project_number node.attr("docnumber"),
            **attr_code(part: part)
        end
      end

      def add_id_parts(dn, part, subpart)
        dn += ".#{part}" if part
        dn += ".#{subpart}" if subpart
        dn
      end

      def id_stage_prefix(dn, node)
        if node.attr("docstage") && node.attr("docstage").to_i < 60
          abbr = IsoDoc::Gb::Metadata.new("en", "Latn", {}).
            status_abbrev(node.attr("docstage"), node.attr("iteration"),
                         node.attr("draft"))
          dn = "/#{abbr} #{dn}" # prefixes added in cleanup
        else
          dn += "-#{node.attr("copyright-year")}" if node.attr("copyright-year")
        end
        dn
      end

      def metadata_language(node, xml)
        xml.language (node.attr("language") || "zh")
      end

      def metadata_script(node, xml)
        xml.script (node.attr("script") || "Hans")
      end

      def metadata_ext(node, xml)
        metadata_doctype(node, xml)
        metadata_committee(node, xml)
        metadata_ics(node, xml)
        structured_id(node, xml)
        metadata_gbtype(node, xml)
        metadata_gblibraryids(node, xml)
      end

      def title_full(node, lang, t, at)
        title = node.attr("title-main-#{lang}")
        intro = node.attr("title-intro-#{lang}")
        part = node.attr("title-part-#{lang}")
        title = "#{intro} -- #{title}" if intro
        title = "#{title} -- #{part}" if part
        t.title **attr_code(at.merge(type: "main")) do |t1|
          t1 << Asciidoctor::Standoc::Utils::asciidoc_sub(title)
        end
      end

      def title_intro(node, lang, t, at)
        node.attr("title-intro-#{lang}") and
          t.title **attr_code(at.merge(type: "title-intro")) do |t1|
          t1 << Asciidoctor::Standoc::Utils::asciidoc_sub(
            node.attr("title-intro-#{lang}"))
        end
      end

      def title_main(node, lang, t, at)
        t.title **attr_code(at.merge(type: "title-main")) do |t1|
          t1 << Asciidoctor::Standoc::Utils::asciidoc_sub(
            node.attr("title-main-#{lang}"))
        end
      end

      def title_part(node, lang, t, at)
        node.attr("title-part-#{lang}") and
          t.title **attr_code(at.merge(type: "title-part")) do |t1|
          t1 << Asciidoctor::Standoc::Utils::asciidoc_sub(
            node.attr("title-part-#{lang}"))
        end
      end

      def title(node, xml)
        ["en", "zh"].each do |lang|
          at = { language: lang, format: "plain" }
          title_full(node, lang, xml, at)
          title_intro(node, lang, xml, at)
          title_main(node, lang, xml, at)
          title_part(node, lang, xml, at)
        end
      end
    end
  end
end
