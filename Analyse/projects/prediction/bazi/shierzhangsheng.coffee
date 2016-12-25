_ = require 'lodash'
{Term} = require './term.coffee'

class Zhangsheng
  constructor: (@name) ->
    @config()
    @zhangshengDizhi = @getDizhiOfTianganZhangsheng()
    @dizhiZhangsheng = @getZhangshengOfTianganDizhi()

  config: () =>
    if not @name
      @name = '甲'
    @zhangshengName = ["长生","沐浴","冠带","临官","帝旺","衰","病","死","墓","绝","胎","养"]
    @tianganZhangsheng =
      "甲":["亥","子","丑","寅","卯","辰","巳","午","未","申","酉","戌"]
      "丙":["寅","卯","辰","巳","午","未","申","酉","戌","亥","子","丑"]
      "戊":["寅","卯","辰","巳","午","未","申","酉","戌","亥","子","丑"]
      "庚":["巳","午","未","申","酉","戌","亥","子","丑","寅","卯","辰"]
      "壬":["申","酉","戌","亥","子","丑","寅","卯","辰","巳","午","未"]
      "乙":["午","巳","辰","卯","寅","丑","子","亥","戌","酉","申","未"]
      "丁":["酉","申","未","午","巳","辰","卯","寅","丑","子","亥","戌"]
      "己":["酉","申","未","午","巳","辰","卯","寅","丑","子","亥","戌"]
      "辛":["子","亥","戌","酉","申","未","午","巳","辰","卯","寅","丑"]
      "癸":["卯","寅","丑","子","亥","戌","酉","申","未","午","巳","辰"]

  ###
    获取一个地支代表的天干的十二长生
    @method getZhangshengOfTianganDizhi
    @param {string} tiangan 天干
    @param {string} dizhi 地支
    @return {string}
  ###
  getZhangshengOfTianganDizhi: (tiangan, dizhi) =>
    if tiangan and not dizhi
      dizhi = tiangan
      tiangan = @name
    else if not tiangan and not dizhi
      tiangan = @name

    if not dizhi
      changshengMap = {}
      _.map @tianganZhangsheng[tiangan], (dz, index) => changshengMap[dz] = @zhangshengName[index]
      changshengMap
    else
      changshengIndex = _.indexOf @tianganZhangsheng[tiangan], dizhi
      @zhangshengName[changshengIndex]

  ###
    获取一个十二长生做代表的地址
    @method getDizhiOfTianganzhangsheng
    @param {string} tiangan 天干
    @param {string} zhangsheng 十二长生
    @return {string}
  ###
  getDizhiOfTianganZhangsheng: (tiangan, zhangsheng) =>
    if tiangan and not zhangsheng
      zhangsheng = tiangan
      tiangan = @name
    else if not tiangan and not zhangsheng
      tiangan = @name

    if not zhangsheng
      changshengMap = {}
      _.map @tianganZhangsheng[tiangan], (dz, index) => changshengMap[@zhangshengName[index]] = dz
      changshengMap
    else
      dizhiIndex = _.indexOf @zhangshengName, zhangsheng
      @tianganZhangsheng[tiangan][dizhiIndex]

exports.Zhangsheng = Zhangsheng
