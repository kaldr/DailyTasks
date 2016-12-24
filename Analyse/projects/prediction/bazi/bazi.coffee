_ = require 'lodash'
{Wuxing} = require './wuxing.coffee'
{Tiangan} = require './tiangan.coffee'
{Dizhi} = require './dizhi.coffee'

class Bazi
  constructor: (bazi) ->
    @baziList = _.compact(_.split (_.trim bazi.replace(/\s/g, ''), ',.-_，。'),'')
    @riganWuxing = new Wuxing @getRigan()
    @riganTiangan = new Tiangan @getRigan()

    @DiZhi = new Dizhi()
    @baziTiangan = @getTiangan()
    @baziDizhi = @getDizhi()
    @getShishen()

    @baziWuxing = @riganWuxing.getRelation bazi

  getShishen: () =>
    @tianganShishen = _.map @baziTiangan, (term) =>@riganTiangan.shiShens[term]
    @dizhiCanggan = _.map @baziDizhi, (term) =>@DiZhi.dizhicanggan term
    @dizhiShishen = _.map @dizhiCanggan, (term) =>
      _.map term, (word) =>@riganTiangan.shiShens[word]
    @baziShishen = [@tianganShishen, @dizhiShishen]

  getTiangan: () =>
    _.filter @baziList, (term, index) =>return true if index % 2 == 0

  getDizhi: () =>
    _.filter @baziList, (term, index) =>return true if index % 2 == 1

  getRigan: () =>
    @baziList[4]

  getYueling: () =>
    @baziList[3]

bazi = new Bazi '丁卯 庚戌 乙未 辛巳'
