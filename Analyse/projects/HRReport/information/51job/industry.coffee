#行业类别
it = {}
it['01']='计算机软件'
it['37']='计算机硬件'
it['38']='计算机服务(系统、数据服务、维修)'
it['31']='通信/电信/网络设备'
it['39']='通信/电信运营、增值服务'
it['32']='互联网/电子商务'
it['40']='网络游戏'
it['02']='电子技术/半导体/集成电路'
it['35']='仪器仪表/工业自动化'
it['41']='会计/审计'
it['03']='金融/投资/证券'
it['42']='银行'
it['43']='保险'
it['62']='信托/担保/拍卖/典当'
it['04']='贸易/进出口'
it['22']='批发/零售'
it['05']='快速消费品(食品、饮料、化妆品)'
it['06']='服装/纺织/皮革'
it['44']='家具/家电/玩具/礼品'
it['60']='奢侈品/收藏品/工艺品/珠宝'
it['45']='办公用品及设备'
it['14']='机械/设备/重工'
it['33']='汽车及零配件'
it['08']='制药/生物工程'
it['46']='医疗/护理/卫生'
it['47']='医疗设备/器械'
it['12']='广告'
it['48']='公关/市场推广/会展'
it['49']='影视/媒体/艺术/文化传播'
it['13']='文字媒体/出版'
it['15']='印刷/包装/造纸'
it['26']='房地产'
it['09']='建筑/建材/工程'
it['50']='家居/室内设计/装潢'
it['51']='物业管理/商业中心'
it['34']='中介服务'
it['63']='租赁服务'
it['07']='专业服务(咨询、人力资源、财会)'
it['59']='外包服务'
it['52']='检测，认证'
it['18']='法律'
it['23']='教育/培训/院校'
it['24']='学术/科研'
it['11']='餐饮业'
it['53']='酒店/旅游'
it['17']='娱乐/休闲/体育'
it['54']='美容/保健'
it['27']='生活服务'
it['21']='交通/运输/物流'
it['55']='航天/航空'
it['19']='石油/化工/矿产/地质'
it['16']='采掘业/冶炼'
it['36']='电气/电力/水利'
it['61']='新能源'
it['56']='原材料和加工'
it['28']='政府/公共事业'
it['57']='非盈利机构'
it['20']='环保'
it['29']='农/林/牧/渔'
it['58']='多元化业务集团公司'
industry = []
oJSJ = {
'title': {'c': '计算机 | 互联网 | 通信 | 电子', 'e': 'Computer, Internet, Telecom, Electronics'} ,
'data': ['01','37','38','31','39','32','40','02','35']
}
industry.push oJSJ
oKJ = {
'title': {'c': '会计/金融/银行/保险', 'e': 'Accounting, Finance, Banking, Insurance'} ,
'data': ['41','03','42','43','62']
}

industry.push oKJ
oMY = {
'title': {'c': '贸易/消费/制造/营运', 'e': 'Trade, Sales, Manufacturing, Operations'} ,
'data': ['04','22','05','06','44','60','45','14','33']
}
industry.push oMY

oZY = {
'title': {'c': '制药/医疗', 'e': 'Pharmaceuticals, Healthcare'} ,
'data': ['08','46','47']
}
industry.push oZY

oGG = {
'title': {'c': '广告/媒体', 'e': 'Advertising, Media Related'} ,
'data': ['12','48','49','13','15']
}

industry.push oGG

oFDC = {
'title': {'c': '房地产/建筑', 'e': 'Real Estates Related'} ,
'data': ['26','09','50','51']
}
industry.push oFDC


oZYFW = {
'title': {'c': '专业服务/教育/培训', 'e': 'Professional Services, Education, Training'} ,
'data': ['34','07','59','52','18','23','24','63']
}
industry.push oZYFW


oFWY = {
'title': {'c': '服务业', 'e': 'Customer Services'} ,
'data': ['11','53','17','54','27']
}

industry.push oFWY

oWL = {
'title': {'c': '物流/运输', 'e': 'Logistics, Transportation'} ,
'data': ['21','55']
}

industry.push oWL


oNY = {
'title': {'c': '能源/原材料', 'e': 'Utilities and Raw Materials Related'} ,
'data': ['19','16','36','61','56']
}

industry.push oNY

oZF = {
'title': {'c': '政府/非赢利机构/其他', 'e': 'Government, Non Profit, Others'} ,
'data': ['28','57','20','29','58']
}
industry.push oZF

connect = require 'mongojs'
_ = require 'lodash'
mongo = 'mongodb://localhost:27017/HRReport'
db = connect mongo




_.forEach industry, (item) ->
  industryIDList = []
  _.forEach item.data, (id) ->
    industryIDList.push {
      id: parseInt id
    }
  db.industry.find {
    $or: industryIDList
  } , (err, docs) ->
    db.domain.update {
      name: item.title.c
    } , {
      name: item.title.c
      industryList: docs
    } , {
      upsert: true
    }



_.forEach it, (item, key) ->
  type = _.find industry, (industryItem) ->
    return true if _.indexOf(industryItem.data, key) >-1
  db.industry.update {
    id: parseInt key
  } , {
    id: parseInt key
    name: item
    type: type.title.c
  } , {
    upsert: true
  }



db._CollectionDictionary.update {
  collectionName: 'domain'
} , {
  collectionName: 'domain'
  title: "领域"
  intro: "每个领域包含多个行业"
  scope: "人力资源中岗位的分类"
  columns:
    name: "领域名称"
    industryList: "包含的领域的列表"
} , {
  upsert: true
}


db._CollectionDictionary.update {
  collectionName: 'industry'
} , {
  collectionName: 'industry'
  title: "行业"
  intro: "每个行业有多个岗位，有多家公司。每个行业有所属的领域。"
  scope: "人力资源中岗位的行业分类"
  columns:
    id: "51job中使用的id"
    name: "行业名称"
    type: "所属的领域"
} , {
  upsert: true
}
