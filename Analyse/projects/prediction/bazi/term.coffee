_ = require 'lodash'

class Term
  constructor: (@name) ->
    @judgeType()

  judgeType: (term) =>
    list = ['天干','地支','十神','长生']
    typeList = [@judgeTiangan(), @judgeDizhi(), @judgeShishen(), @judgeZhangsheng() ]
    _.map typeList, (b, index) =>
      if b
        @type = list[index]
  judge: (term, list) =>
    if not term
      term = @name
    if _.indexOf(list, term) >-1
      return true
    else
      return false

  judgeZhangsheng: (zhangsheng) =>
    zhangshengList = ["长生", "沐浴", "冠带", "临官", "帝旺", "衰", "病", "死", "墓", "绝", "胎", "养"]
    zhangshengShortList = ["长","生", "沐", "冠", "临","官","旺", "帝", "衰", "病", "死", "墓", "绝", "胎", "养"]
    if not @judge zhangsheng, zhangshengList
      @judge zhangsheng, zhangshengShortList
    else
      true

  judgeShishen: (shishen) =>
    shishenList = ["比肩", "劫财", "食神", "伤官", "偏财", "正财", "七杀", "正官", "偏印", "正印"]
    shishenShortList = ["比", "劫", "食", "伤", "才", "财", "杀", "官", "枭", "印", '鬼']
    if not @judge(shishen, shishenList)
      @judge shishen, shishenShortList
    else
      true

  judgeDizhi: (dizhi) =>
    dizhiList = ["亥", "子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌"]
    @judge dizhi, dizhiList

  judgeTiangan: (tiangan) =>
    tianganList = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
    @judge tiangan, tianganList

exports.Term = Term
