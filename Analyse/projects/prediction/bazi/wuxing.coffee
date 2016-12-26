_ = require 'lodash'

class Wuxing

  constructor: (@name) ->
    @elementList = ['木','火','土','金','水']
    @relation = ['助','生','克','被克','被生']
    @wuxing = @getWuxing @name
    @wuxingIndex = _.indexOf @elementList, @wuxing

  setName: (name) =>
    @name = name
    @wuxing = @getWuxing @name
    @wuxingIndex = _.indexOf @elementList, @wuxing
    @

  getRelation: (list) =>
    if typeof list == 'string'
      list = list.replace(/\s/g, '')
      list = _.compact(_.split (_.trim list, ',.-_，。'),'')
    wuxingOfList = @getWuxingOfTerms list
    relationOfList = @getWuxingRelationOfTerms list
    relation = {}
    _.map list, (term, index) =>
      relation[term] =
        wuxing: wuxingOfList[index]
        relation: relationOfList[index]
    relation

  getWuxingRelationOfTerms: (list) =>
    _.map list, @getWuxingRelationOfATerm

  getWuxingRelationOfATerm: (term) =>
    termWuxing = @getWuxing term
    termWuxingIndex = _.indexOf @elementList, termWuxing
    relativeIndex = termWuxingIndex - @wuxingIndex
    if relativeIndex < 0
      relativeIndex += 5
    @relation[relativeIndex]

  getWuxingOfTerms: (list) =>
    _.map list, @getWuxing

  getWuxing: (term) =>
    @wuxingList =
      '甲':'木'
      '乙':'木'
      '丙':'火'
      '丁':'火'
      '戊':'土'
      '己':'土'
      '庚':'金'
      '辛':'金'
      '壬':'水'
      '癸':'水'
      '子':'水'
      '丑':'土'
      '寅':'木'
      '卯':'木'
      '辰':'土'
      '巳':'火'
      '午':'火'
      '未':'土'
      '申':'金'
      '酉':'金'
      '戌':'土'
      '亥':'水'
    if @wuxingList[term] then return @wuxingList[term] else return ''

exports.Wuxing = Wuxing
