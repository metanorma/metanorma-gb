require "isodoc"
require_relative "./gbcleanup.rb"
require_relative "./metadata.rb"

module IsoDoc
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class Common < IsoDoc::Common
      def initialize(options)
        @meta = options[:meta]
      end

      def fileloc(loc)
        File.join(File.dirname(__FILE__), loc)
      end

      def format_agency(agency, format)
        return agency unless agency.is_a?(Array)
        if agency == ["中华人民共和国国家质量监督检验检疫总局", "中国国家标准化管理委员会"]
          logo = "gb-issuer-default.gif"
          system "cp #{fileloc(File.join('html/gb-logos', logo))}  #{logo}"
          return "<img src='#{logo}' alt='#{agency.join(",")}'></img>"
        end
        format_agency1(agency, format)
      end

      def format_agency1(agency, format)
        ret = "<table>"
        agency.each { |a| ret += "<tr><td>#{a}</td></tr>" }
        ret += "</table>"
        ret.gsub!(/<table>/, "<table width='100%'>") if format == :word
        ret
      end

      def format_logo(prefix, scope, _format)
        return "" if %w(enterprise social-group).include? scope
        logo = @meta.standard_logo(prefix)
        if logo.nil?
          "<span style='font-size:36pt;font-weight:bold'>#{prefix}</span>"
        else
          format_logo1(logo, prefix, scope)
        end
      end

      def local_logo_suffix(scope)
        return "" if scope != "local"
        local = @meta.get[:docidentifier][2,2]
        "<span style='font-weight:bold'>#{local}</span>"
      end


      def format_logo1(logo, prefix, scope)
        logo += ".gif"
        system "cp #{fileloc(File.join('html/gb-logos', logo))}  #{logo}"
        local = local_logo_suffix(scope)
        #@files_to_delete << logo
        "<img width='113' height='56' src='#{logo}' alt='#{prefix}'></img>"\
          "#{local}"
      end
    end
  end
end
