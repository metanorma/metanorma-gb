# frozen_string_literal: true

module Metanorma
  module Gb
    module Html
      # GB documents render iso-style; the GB root uses the ISO
      # section classes the parent renderer already registers — only
      # the root itself needs dispatch (exact-class, OGC pattern).
      class Renderer < Metanorma::Iso::Html::Renderer
        register_render "Metanorma::Gb::Document::Root", :render_document

        # GB covers append the issue/implementation date block and the
        # issuing authorities line after the ISO cover.
        def render_coverpage(doc)
          super + gb_cover_extras(doc)
        end

        def gb_cover_extras(doc)
          bibdata = doc.bibdata
          return "" unless bibdata

          dates = gb_dates(bibdata)
          issuer = gb_issuer(bibdata)
          return "" if dates.empty? && issuer.nil?

          inner = dates
          inner += %(<div class="coverpage_footer">#{escape_html(issuer)}</div>) if issuer
          render_liquid("_element.html.liquid", {
                          "tag" => "div",
                          "extra_attrs" => element_attrs(class: "gb-cover-extras"),
                          "content" => inner,
                        })
        end

        # Native labels: "Issuance Date:" (published) and
        # "Implementation Date:" (implementation/implemented).
        def gb_dates(bibdata)
          labels = {
            "published" => "Issuance Date",
            "implementation" => "Implementation Date",
            "implemented" => "Implementation Date",
          }
          items = Array(safe_attr(bibdata, :date)).filter_map do |d|
            type = cover_date_text(safe_attr(d, :type)) || safe_attr(d, :type)
            label = labels[type]
            next unless label

            on = cover_date_text(safe_attr(d, :on)) ||
                 cover_date_text(safe_attr(d, :from))
            next unless on

            %(<span class="date-#{type == 'published' ? 'publish' : 'active'}">#{label}: #{escape_html(on)}</span>)
          end
          return "" if items.empty?

          render_liquid("_element.html.liquid", {
                          "tag" => "div",
                          "extra_attrs" => element_attrs(class: "coverpage-dates"),
                          "content" => items.join,
                        })
        end

        # The issuing authority organization (role "issuer").
        def gb_issuer(bibdata)
          Array(safe_attr(bibdata, :contributor)).each do |c|
            roles = Array(safe_attr(c, :role))
            is_issuer = roles.any? do |r|
              type = r.is_a?(String) ? r : cover_date_text(safe_attr(r, :type))
              type == "issuer"
            end
            next unless is_issuer

            org = safe_attr(c, :organization)
            name = org ? cover_date_text(safe_attr(org, :name)) : nil
            return name if name && !name.empty?
          end
          nil
        end
      end
    end
  end
end
