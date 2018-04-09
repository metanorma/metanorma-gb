module Asciidoctor
  module Gb
    class Converter < ISO::Converter
      def standard_type(node)
        type = node.attr("mandate") || "mandatory"
        type = "standard" if type == "mandatory"
        type = "recommendation" if type == "recommended"
        type
      end

      def front(node, xml)
        xml.bibdata **attr_code(type: standard_type(node)) do |b|
          metadata node, b
        end
        metadata_version(node, xml)
      end

      def metadata_author(node, xml)
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
        attrs = { type: node.attr("technical-committee-type") }
        xml.gbcommittee **attr_code(attrs) do |a|
          a << node.attr("technical-committee")
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
        warn "GB: no scope supplied, defaulting to National"
        "national"
      end

      def get_prefix(node)
        scope = get_scope(node)
        if prefix = node.attr("prefix")
          prefix.gsub!(%r{/.*$}, "")
        else
          prefix = "GB"
          scope = "national"
          warn "GB: no prefix supplied, defaulting to GB"
        end
        [scope, prefix]
      end

      def get_mandate(node)
        node.attr("mandate") and return node.attr("mandate")
        if %r{/}.match? node.attr("prefix")
          m = node.attr("prefix").split(%{/})
          mandate = m[1] == "T" ? "recommended" :
            m[1] == "Z" ? "guidelines" : nil
        end
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

      def metadata_date1(node, xml, type)
        date = node.attr("#{type}-date")
        date and xml.date **{ type: type } do |d|
          d.from date
        end
      end

      DATETYPES = %w{ published accessed created implemented obsoleted
                      confirmed updated issued 
      }.freeze

      def metadata_date(node, xml)
        DATETYPES.each do |t|
          metadata_date1(node, xml, t)
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

      def metadata_contributors(node, xml)
        metadata_author(node, xml)
        metadata_contributor1(node, xml, "author-committee", "author")
        metadata_contributor1(node, xml, "publisher", "publisher")
        metadata_contributor1(node, xml, "authority", "authority")
        metadata_contributor1(node, xml, "proposer", "proposer")
        metadata_contributor1(node, xml, "issuer", "issuer")
      end

      def metadata(node, xml)
        title node, xml
        metadata_id(node, xml)
        metadata_date(node, xml)
        metadata_contributors(node, xml)
        xml.language (node.attr("language") || "zh")
        xml.script (node.attr("script") || "Hans")
        metadata_status(node, xml)
        metadata_copyright(node, xml)
        metadata_equivalence(node, xml)
        metadata_obsoletes(node, xml)
        metadata_ics(node, xml)
        metadata_committee(node, xml)
        metadata_gbtype(node, xml)
        metadata_gblibraryids(node, xml)
      end

      def title(node, xml)
        ["en", "zh"].each do |lang|
          xml.title do |t|
            at = { language: lang, format: "plain" }
            node.attr("title-intro-#{lang}") and
              t.title_intro **attr_code(at) do |t1|
              t1 << node.attr("title-intro-#{lang}")
            end
            t.title_main **attr_code(at) do |t1|
              t1 << node.attr("title-main-#{lang}")
            end
            node.attr("title-part-#{lang}") and
              t.title_part **attr_code(at) do |t1|
              t1 << node.attr("title-part-#{lang}")
            end
          end
        end
      end
    end
  end
end
