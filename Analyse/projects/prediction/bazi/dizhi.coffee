_ = require 'lodash'

class Dizhi
  constructor: (@name) ->
    @config()
    @canggan = @dizhicanggan(@name)
    @dizhiHai = @hai(@name)
    @dizhiLiuhe = @liuhe(@name)
    @dizhiSanhe = @sanhe(@name)
    @dizhiXing = @xing(@name)
    @dizhiHui = @hui(@name)

  config: () =>
    @huiConfig(@name)
    @haiConfig(@name)
    @dizhiRelation =
      '地支': @name
      '藏干': @dizhicanggan(@name)
      '害': @haiDizhi[@name]
      '会': @huiDizhi[@name]

  ###
    获取三会或者半会的五行
    @method getHuiWuxing
    @param {string} dizhi 地支
    @return {string} 五行
  ###
  getHuiWuxing: (dizhi) =>
    result = ''
    _.map @huiList, (dizhiList, wuxing) =>
      containsArray = _.compact(_.map dizhiList, (dizhiListItem) => return true if dizhiListItem == dizhi)
      result = wuxing if containsArray.length > 0
    result

  ###
    三会局的判断
    @method huiConfig
    @return {object} 数组
  ###
  huiConfig: () =>
    @huiDizhi = {}
    @huiList = {
      '木': ["寅","卯","辰"]
      '火': ["巳","午","未"]
      '水': ["亥","子","丑"]
      '金': ["申","酉","戌"]
    }
    _.map @huiList, (dizhiList, wuxing) =>
      _.map dizhiList, (dizhi) =>
        @huiDizhi[dizhi] = _.without dizhiList, dizhi
  ###
    判断是输入的地支列表中是否有会的情况出现
    @method hui
    @param {string} dizhi 当前地址
    @param {array} list 输入地支列表
    @return {array|boolean} 有会，则为array，无会，则为false
  ###
  hui: (dizhi, list) =>
    if not list
      @huiDizhi[dizhi]
    else if typeof list != 'object'
      console.log '判断地支会时必须输入地支的数组，不能输入文字'
    else if list.length < 1
      console.log '判断地支会时数组的长度不能小于1'
    else
       list = _.uniq list
       resultList = _.compact _.map(list, (item) => return item if _.indexOf(@huiDizhi[dizhi], item) >-1)
       if resultList.length > 0
         resultList
       else
         false

  ###
    从输入的地支列表中寻找会
    @method findHuiInDizhiList
    @param {array} list 地支列表
    @return {array|boolean} 没有会则为false，否则是数组
  ###
  findHuiInDizhiList: (list) =>
    if typeof list!='object'
      console.log '输入必须是地支列表'
    else if list.length < 2
      console.log '输入列表的长度不能小于2'
    else
      huiArray = {'半会':[],'三会': []}
      withoutList = []
      _.map list, (item) =>
        return if _.indexOf(withoutList, item) >-1
        withoutList.push item
        inputList = _.filter list, (i) => return true if _.indexOf(withoutList, i) == - 1
        return if inputList.length < 1
        huiResult = @hui item, inputList
        if huiResult
          _.map huiResult, (huiResultItem) => withoutList.push huiResultItem
          huiResult.push item
          if huiResult.length == 3
            huiArray['三会'].push huiResult
          else if huiResult.length == 2
            huiArray['半会'].push huiResult
      if huiArray['三会'].length==0 and huiArray['半会'].length == 0
        huiArray = false
      else if huiArray['半会'].length == 0
        huiArray = {
          '三会': huiArray['三会']
        }
      else if huiArray['三会'].length == 0
        huiArray = {
          '半会': huiArray['半会']
        }
      if not huiArray
        result = false
      else
        result = {}
        _.map ['三会','半会'], (term) =>
          _.map huiArray[term], (huiArrayItem) =>
            wuxing = @getHuiWuxing huiArrayItem[0]
            result[term] = {} if not result[term]
            result[term][wuxing] = huiArrayItem
      result

  ###
    配置六害
    @method haiConfig
    @param {string} dizhi 地支
    @return {无} 无
  ###
  haiConfig: (dizhi) =>
    @haiDizhi = {}
    @haiList = [
      ['子','未']
      ['丑','午']
      ['戌','酉']
      ['亥','申']
      ['辰','卯']
      ['寅','巳']
    ]
    _.map @haiList, (haiListItem) =>
      _.map haiListItem, (haiListItemDizhi) =>
        @haiDizhi[haiListItemDizhi] = _.without(haiListItem, haiListItemDizhi)[0]

  ###
    查找对应地支的害的情况
    @method hai
    @param {string} dizhi 地支
    @param {array} list 要查询的地支数组
    @return {string|boolean} 如果没有害，则为false
  ###
  hai: (dizhi, list) =>
    if not list
      @haiDizhi[dizhi]
    else if typeof list!='object'
      console.log '输入的内容必须为地支列表'
    else
      if _.indexOf(list, @haiDizhi[dizhi]) >-1 then return @haiDizhi[dizhi] else return false

  ###
    查找一个地支列表中所有的害
    @method findHaiInDizhiList
    @param {array} list 地支列表
    @return {array} 所有害的列表
  ###
  findHaiInDizhiList: (list) =>
    haiArray = []
    if typeof list != 'object'
      console.log '输入必须是列表'
    else if list.length < 2
      console.log '列表中地支数量不得小于2'
    else
      withoutList = []
      _.map list, (item) =>
        return if _.indexOf(withoutList, item) >-1
        withoutList.push item
        inputList = _.filter list, (listItem) =>return true if _.indexOf(withoutList, item) >-1
        return if inputList.length < 1
        currentHaiDizhi = @hai item, inputList
        if currentHaiDizhi
          currentResult = [currentHaiDizhi, item]
          withoutList.push currentHaiDizhi
          haiArray.push currentResult
    if haiArray.length == 0
      haiArray = false
    haiArray

  chong: (dizhi, list) =>

  liuhe: (dizhi, list) =>

  banhe: (dizhi, list) =>

  sanhe: (dizhi, list) =>

  xing: (dizhi, list) =>

  ###
    找到一个地支的藏干
    @method dizhicanggan
    @param {string} dizhi 地址
    @return {array} 藏干列表
  ###
  dizhicanggan: (dizhi) =>
    canggan =
      '子': ['癸']
      '丑': ['己','癸','辛']
      '寅': ["甲","丙","戊"]
      '卯': ["乙"]
      '辰': ["戊",'乙','癸']
      '巳': ["丙",'庚','戊']
      '午': ['丁','己']
      '未': ['己','丁','乙']
      '申': ['庚','壬','戊']
      '酉': ['辛']
      '戌': ['戊','辛','丁']
      '亥': ['壬','甲']
    if dizhi then return canggan[dizhi] else return cangan

exports.Dizhi = Dizhi


dz = new Dizhi '戌'
#console.log dz.huiDizhi['亥']
#console.log dz.findHuiInDizhiList [ "午", "未","丑", "卯","子", "辰", "巳", "巳", "午","午","午","午", "未", "申"]
#console.log dz.findHuiInDizhiList ['卯','戌','未','巳']
#console.log dz.findHuiInDizhiList ['辰','丑','酉','丑']
console.log dz.findHaiInDizhiList ['辰','丑','酉','丑']
#console.log dz.haiDizhi
#console.log dz.dizhiRelation
#console.log dz.hai '酉',['亥','戌']
