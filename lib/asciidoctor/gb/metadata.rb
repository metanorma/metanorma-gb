module Asciidoctor
  module Gb
    class Converter < ISO::Converter
      def metadata_author(node, xml)
        xml.contributor do |c|
          c.role **{ type: "author" }
          c.organization do |a|
            a.name "GB"
          end
        end
      end

      def metadata_publisher(node, xml)
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
        attrs = {type: node.attr("technical-committee-type") }
        xml.gbcommittee **attr_code(attrs) do |a|
          a << node.attr("technical-committee")
        end
      end

      def metadata_equivalence(node, xml)
        xml.gbequivalence { |a| a << node.attr("equivalence") }
      end

      def metadata_gbtype(node, xml)
        xml.gbtype do |t| 
          t.gbscope { |s| s << node.attr("scope") }
          t.gbprefix { |p| p << node.attr("prefix") }
          t.gbmandate { |m| m << node.attr("mandate") }
        end
      end

      def metadata_date(node, xml)
        pubdate = node.attr("published-date")
        activdate = node.attr("activated-date")
        xml.date(pubdate, **{ type: "published" }) if pubdate
        xml.date(activdate, **{ type: "activated" }) if activdate
      end

      def metadata(node, xml)
        title node, xml
        metadata_id(node, xml)
        metadata_date(node, xml)
        metadata_author(node, xml)
        metadata_publisher(node, xml)
        xml.language "zh"
        xml.script "Hans"
        metadata_status(node, xml)
        metadata_copyright(node, xml)
        metadata_committee(node, xml)
        metadata_equivalence(node, xml)
        metadata_gbtype(node, xml)
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
