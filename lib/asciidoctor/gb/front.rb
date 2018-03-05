module Asciidoctor
  module Gb
    class Converter < ISO::Converter
      def metadata_author(_node, xml)
        xml.contributor do |c|
          c.role **{ type: "author" }
          c.organization do |a|
            a.name "GB"
          end
        end
      end

      def metadata_publisher(_node, xml)
        xml.contributor do |c|
          c.role **{ type: "publisher" }
          c.organization do |a|
            a.name "GB"
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
        unless scope = node.attr("scope")
          scope = "national"
          warn "GB: no scope supplied, defaulting to National"
        end
        scope
      end

      def get_prefix(node)
        scope = get_scope(node)
        unless prefix = node.attr("prefix")
          prefix = "GB"
          scope = "national"
          warn "GB: no prefix supplied, defaulting to GB"
        end
        [scope, prefix]
      end

      def get_mandate(node)
        unless mandate = node.attr("mandate")
          mandate = "mandatory"
          warn "GB: no mandate supplied, defaulting to mandatory"
        end
        mandate
      end

      def metadata_gbtype(node, xml)
        xml.gbtype do |t|
          scope, prefix = get_prefix(node)
          t.gbscope { |s| s << scope }
          t.gbprefix { |p| p << prefix }
          t.gbmandate { |m| m << get_mandate(node) }
        end
      end

      def metadata_date(node, xml)
        pubdate = node.attr("published-date")
        activdate = node.attr("activated-date")
        xml.date(pubdate, **{ type: "published" }) if pubdate
        xml.date(activdate, **{ type: "activated" }) if activdate
      end

      def metadata_gblibraryids(node, xml)
        ics = node.attr("library-ics")
        l = node.attr("library-l")
        if ics || l
          xml.gblibraryids do |g|
            xml.ics ics if ics
            xml.l l if l
          end
        end
      end

      def metadata(node, xml)
        title node, xml
        metadata_id(node, xml)
        metadata_date(node, xml)
        metadata_author(node, xml)
        metadata_publisher(node, xml)
        xml.language (node.attr("language") || "zh")
        xml.script (node.attr("script") || "Hans")
        metadata_status(node, xml)
        metadata_copyright(node, xml)
        metadata_equivalence(node, xml)
        metadata_obsoletes(node, xml)
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

      def title_intro_validate(root)
        title_intro_en = root.at("//title-intro[@language='en']")
        title_intro_zh = root.at("//title-intro[@language='zh']")
        if title_intro_en.nil? && !title_intro_zh.nil?
          warn "No English Title Intro!"
        end
        if !title_intro_en.nil? && title_intro_zh.nil?
          warn "No Chinese Title Intro!"
        end
      end

      def title_part_validate(root)
        title_part_en = root.at("//title-part[@language='en']")
        title_part_zh = root.at("//title-part[@language='zh']")
        if title_part_en.nil? && !title_part_zh.nil?
          warn "No English Title Part!"
        end
        if !title_part_en.nil? && title_part_zh.nil?
          warn "No Chinese Title Part!"
        end
      end
    end
  end
end
