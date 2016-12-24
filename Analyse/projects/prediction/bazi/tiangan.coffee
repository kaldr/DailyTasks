_ = require 'lodash'

class Tiangan
  constructor: (@name) ->
    @configTianganList()
    @configShiShen()
    _.map @tianganList, @tianganRelation

  configElement: () =>
    @element = ['木','火','土','金','水']
    @relation = ['扶助','生','克','被克','被生']

  configShiShen: () =>
    @shiShenList = ['比肩','劫财','食神','伤官','偏财','正财','偏官','正官','偏印','正印']
    @shiShens = @shiShen()

  tianganHe: () =>
    @yangHe = {

    }
    @yinHe = {

    }
  configTianganList: () =>
    @tianganList = ['甲','乙','丙','丁','戊','己','庚','辛','壬','癸']
    @tianganYinList = ['乙','甲','丁','丙','己','戊','辛','庚','癸','壬']
    @tianganIndex = _.indexOf @tianganList, @name
    @tianganYinIndex = _.indexOf @tianganYinList, @name

  tianganRelation: (tiangan) =>
    if not tiangan
      console.log "请输入要与#{@name}判断的天干"
    else
      tianganIndex = _.indexOf(@tianganList, tiangan)
      thisIndex = _.indexOf(@tianganList, @name)
      #console.log tianganIndex - thisIndex, tiangan

  ###
    天干的阴阳
    @method tianganYinYang
    @param {String} tiangan = "" 天干
    @return {Integer} 天干的阴阳，0为阴，1为阳
  ###
  tianganYinYang: (tiangan = "") =>
    if not tiangan
      tiangan = @name
    index = _.indexOf @tianganList, tiangan
    if index % 2 == 0 then return 1 else return 0

  mapIndex : (tg) =>
    if not @tianganYinYang() #阴性天干
      currentIndex = (_.indexOf(@tianganYinList, tg) - @tianganYinIndex)
    else
      currentIndex = _.indexOf(@tianganList, tg) - @tianganIndex
    if currentIndex < 0
      currentIndex += 10
    currentIndex

  shiShen: (tiangan = '') =>
    if not tiangan
      shiShens = _.map @tianganList, (tg) => @shiShenList[@mapIndex(tg) ]
      result = {}
      _.forEach shiShens, (ss, index) =>
        result[@tianganList[index]] = ss
      result
    else
      index = @mapIndex(tiangan)
      @shiShenList[index ]

exports.Tiangan = Tiangan
