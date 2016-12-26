_ = require 'lodash'
{Wuxing} = require './wuxing.coffee'
{Tiangan} = require './tiangan.coffee'
{Dizhi} = require './dizhi.coffee'
{Zhangsheng} = require './shierzhangsheng.coffee'

class LiuShiJiaZi

  constructor: () ->
    @Wuxing = new Wuxing()
    @Zhangsheng = new Zhangsheng()
    @config()
    @constructLiuShiJiaZi()
    @calculateRelation()

  config: () =>
    @tiangan = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
    @dizhi = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌","亥"]

  yinyang: (term) =>
    if _.indexOf(@tiangan, term) % 2 == 0 then return '阳' else return '阴'

  constructLiuShiJiaZi: () =>
    @jiazi = []
    tiangans = []
    dizhis = []
    tiangans.push @tiangan for i in [0...6]
    dizhis.push @dizhi for i in [0...5]
    tiangans = _.flatten tiangans
    dizhis = _.flatten dizhis
    @jiazi.push [tiangans[i], dizhis[i]] for i in [0...60]

  calculateRelation: () =>
    @jiaziRelation = {}
    _.map @jiazi, (jiazi, index) =>
      jiaziOb =
        index: index
        year: 124 + index
        tiangan:
          name: jiazi[0]
          yingyang: @yinyang jiazi[0]
          wuxing: @Wuxing.getWuxing jiazi[0]
          relationToDizhi: @Wuxing.setName(jiazi[0]).getWuxingRelationOfATerm(jiazi[1])
        dizhi:
          name: jiazi[1]
          yingyang: @yinyang jiazi[0]
          wuxing: @Wuxing.getWuxing jiazi[1]
          relationToTiangan: @Wuxing.setName(jiazi[1]).getWuxingRelationOfATerm(jiazi[0])
        name: jiazi.join("")
        zhangsheng: @Zhangsheng.getZhangshengOfTianganDizhi jiazi[0], jiazi[1]
      @jiaziRelation[jiazi.join("") ] = jiaziOb

  relation: (tiangan, dizhi) =>
    if typeof tiangan == 'string'
      if tiangan.length == 2
        @jiaziRelation[tiangan]
      else if tiangan.length == 1 and dizhi.length == 1
        @jiaziRelation[tiangan + dizhi]
    else if typeof tiangan == 'number'
      index = tiangan - (Math.floor tiangan / 60 - 2) * 60#只计算公元124年之后的六十甲子
      _.find @jiaziRelation, {"year": index}
    else if typeof tiangan == 'object'
      @jiaziRelation[tiangan.join("") ]

a = new LiuShiJiaZi()
console.log a.jiaziRelation
