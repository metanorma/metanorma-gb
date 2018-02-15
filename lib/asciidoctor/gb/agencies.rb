require "isodoc"

module Asciidoctor
  module Gb
    # A {Converter} implementation that generates GB output, and a document
    # schema encapsulation of the document for validation
    class GbConvert < IsoDoc::Convert

      sector = {
        "AQ": { industry: "安全生产", admin: "国家安全生产管理局"},
        "BB": { industry: "包装", admin: "国家发改委"},
        "CB": { industry: "船舶", admin: "国防科学工业委员会"},
        "CH": { industry: "测绘", admin: "国家测绘局"},
        "CJ": { industry: "城镇建设", admin: "建设部"},
        "CY": { industry: "新闻出版", admin: "国家新闻出版总署"},
        "DA": { industry: "档案", admin: "国家档案局"},
        "DB": { industry: "地震", admin: "中国地震局"},
        "DL": { industry: "电力", admin: "国家发改委"},
        "DZ": { industry: "地质矿产", admin: "国土资源部"},
        "EJ": { industry: "核工业", admin: "国防科学工业委员会"},
        "FZ": { industry: "纺织", admin: "国家发改委"},
        "GA": { industry: "公共安全", admin: "公安部"},
        "GH": { industry: "供销", admin: "中华全国供销合作总社"},
        "GM": { industry: "密码", admin: "国家密码管理局"},
        "GY": { industry: "广播电影电视", admin: "国家广播电影电视总局"},
        "HB": { industry: "航空", admin: "国防科学工业委员会"},
        "HG": { industry: "化工", admin: "国家发改委"},
        "HJ": { industry: "环境保护", admin: "国家环境保护总局"},
        "HS": { industry: "海关", admin: "海关总署"},
        "HY": { industry: "海洋", admin: "国家海洋局"},
        "JB": { industry: "机械", admin: "国家发改委"},
        "JC": { industry: "建材", admin: "国家发改委"},
        "JG": { industry: "建筑工业", admin: "建设部"},
        "JR": { industry: "金融", admin: "中国人民银行"},
        "JT": { industry: "交通", admin: "交通部"},
        "JY": { industry: "教育", admin: "教育部"},
        "LB": { industry: "旅游", admin: "国家旅游局"},
        "LD": { industry: "劳动和劳动安全", admin: "劳动和社会保障部"},
        "LS": { industry: "粮食", admin: "国家粮食局"},
        "LY": { industry: "林业", admin: "国家林业局"},
        "MH": { industry: "民用航空", admin: "中国民航管理总局"},
        "MT": { industry: "煤炭", admin: "国家发改委"},
        "MZ": { industry: "民政", admin: "民政部"},
        "NY": { industry: "农业", admin: "农业部"},
        "QB": { industry: "轻工", admin: "国家发改委"},
        "QC": { industry: "汽车", admin: "国家发改委"},
        "QJ": { industry: "航天", admin: "国防科学工业委员会"},
        "QX": { industry: "气象", admin: "中国气象局"},
        "SB": { industry: "国内贸易", admin: "商务部"},
        "SC": { industry: "水产", admin: "农业部"},
        "SH": { industry: "石油化工", admin: "国家发改委"},
        "SJ": { industry: "电子", admin: "信息产业部"},
        "SL": { industry: "水利", admin: "水利部"},
        "SN": { industry: "商检", admin: "国家质量监督检验检疫总局"},
        "SY": { industry: "石油天然气", admin: "国家发改委"},
        "TB": { industry: "铁道", admin: "铁道部"},
        "TD": { industry: "土地管理", admin: "国土资源部"},
        "TJ": { industry: "铁道交通", admin: "铁道部标准所"},
        "TY": { industry: "体育", admin: "国家体育总局"},
        "WB": { industry: "物资管理", admin: "国家发改委"},
        "WH": { industry: "文化", admin: "文化部"},
        "WJ": { industry: "兵工民品", admin: "国防科学工业委员会"},
        "WM": { industry: "外经贸", admin: "外经贸部科技司"},
        "WS": { industry: "卫生", admin: "卫生部"},
        "WW": { industry: "文物保护", admin: "国家文物局"},
        "XB": { industry: "稀土", admin: "国家发改委稀土办公室"},
        "YB": { industry: "黑色冶金", admin: "国家发改委"},
        "YC": { industry: "烟草", admin: "国家烟草专卖局"},
        "YD": { industry: "通信", admin: "信息产业部"},
        "YS": { industry: "有色冶金", admin: "国家发改委"},
        "YY": { industry: "医药", admin: "国家食品药品监督管理局"},
        "YZ": { industry: "邮政", admin: "国家邮政局"},
        "ZY": { industry: "中医药", admin: "国家中医药管理局"},
      }

      national: {
        "GB": { name: "中华人民共和国国家标准", admin: "中华人民共和国国家质量监督检验检疫总局，中国国家标准化管理委员会"},
        "GB/T": { name: "中华人民共和国国家标准", admin: "国家质量监督检验检疫总局"},
        "GB/Z": { name: "中华人民共和国国家标准化指导性技术文件", admin: "国家质量监督检验检疫总局"},
        "GBZ": { name: "中华人民共和国国家职业卫生标准", admin: "中华人民共和国卫生部"},
        "GJB": { name: "中华人民共和国国家军用标准", admin: "中国人民解放军装备总部"},
        "GBn": { name: "中华人民共和国国家内部标准" , admin: ""},
        "GHZB": { name: "中华人民共和国国家环境质量标准" , admin: ""},                                                                                                                  "GWKB": { name: "中华人民共和国国家环境保护标准", admin: "环境保护部"},
        "GWPB": { name: "中华人民共和国国家污染物排放标准" , admin: ""},
        "JJF": { name: "中华人民共和国国家计量技术规范", admin: "国家质量监督检验检疫总局"},
        "JJG": { name: "中华人民共和国国家计量检定规程", admin: "国家质量监督检验检疫总局"},
      }

      local: {
        "11": "北京市",
        "12": "天津市",
        "13": "河北省",
        "14": "山西省",
        "15": "内蒙古自治区",
        "21": "辽宁省",
        "22": "吉林省",
        "23": "黑龙江省",
        "31": "上海市",
        "32": "江苏省",
        "33": "浙江省",
        "34": "安徽省",
        "35": "福建省",
        "36": "江西省",
        "37": "山东省",
        "41": "河南省",
        "42": "湖北省",
        "43": "湖南省",
        "44": "广东省",
        "45": "广西壮族自治区",
        "46": "海南省",
        "50": "重庆市",
        "51": "四川省",
        "52": "贵州省",
        "53": "云南省",
        "54": "西藏自治区",
        "61": "陕西省",
        "62": "甘肃省",
        "63": "青海省",
        "64": "宁夏回族自治区",
        "65": "新疆维吾尔自治区",
        "71": "台湾省",
        "81": "香港特别行政区",
        "82": "澳门特别行政区",
      }

      def mandate_suffix(prefix, mandate)
        if prefix == "GB"
          prefix += "/T" if gbmandate == "recommended"
          prefix += "/Z" if gbmandate == "guide"
        end
        prefix
      end

      def standard_class(scope, prefix, mandate)
        case scope
        when "national"
          national[mandate_suffix(prefix)][:name]
        when "sector"
          "中华人民共和国#{sector[prefix][:industry]}行业标准"
        when "professional" # TODO
          "PROFESSIONAL STANDARD"
        when "local" # TODO
          "LOCAL STANDARD"
        when "enterprise" # TODO
          "ENTERPRISE STANDARD"
        end
      end

      def standard_agency(scope, prefix, mandate)
        case scope
        when "national"
          national[mandate_suffix(prefix)][:admin]
        when "sector"
          sector[prefix][:admin]
        when "professional" # TODO
          "PROFESSIONAL STANDARD"
        when "local" # TODO
          "LOCAL STANDARD"
        when "enterprise" # TODO
          "ENTERPRISE STANDARD"
        end
      end

    end
  end
end
