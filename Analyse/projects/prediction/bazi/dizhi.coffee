_ = require 'lodash'
util = require 'util'

###
  地支类，包含判断地支之间的关系
###
class Dizhi
  constructor: (@name) ->
    @config()

  setName: (@name) =>
    @config()
    @dizhiRelation =
      '地支': @name
      '藏干': @dizhicanggan(@name)
      '害': @haiDizhi[@name]
      '会': @huiDizhi[@name]
      '六合': @liuheDizhi[@name]
      "冲": @liuchongDizhi[@name]
      '三合': @sanheDizhi[@name]
      '刑': @xingDizhi[@name]
      '刑(->)': @xingDizhiWithDirection[@name]
      '刑(<-)': @beiXingDizhiWithDirection[@name]
    @
  config: () =>
    @xingConfig()
    @huiConfig()
    @liuchongConfig()
    @haiConfig()
    @liuheConfig()
    @sanheConfig()

  xingConfig: () =>
    @xingList =
      '子':'卯'
      '卯':'子'
      '辰':'辰'
      '午':'午'
      '酉':'酉'
      '亥':'亥'
      '寅': "巳"
      "巳":"申"
      "申":"寅"
      "丑":"戌"
      "戌":"未"
      "未":"丑"
    @xingHuList = [
      ['子','卯']
      ['丑','未','戌']
      ['寅','巳','申']
    ]
    @xingSelfList = ['辰','午','酉','亥']
    @xingDizhiWithDirection = @xingList
    @beiXingDizhiWithDirection =
      '子':'卯'
      '卯':'子'
      '辰':'辰'
      '午':'午'
      '酉':'酉'
      '亥':'亥'
      "巳": '寅'
      "申":"巳"
      "寅":"申"
      "戌":"丑"
      "未":"戌"
      "丑":"未"
    @xingDizhi = {
      '子':['卯']
      '卯':['子']
      '辰':['辰']
      '午':['午']
      '酉':['酉']
      '亥':['亥']
      '寅': ["巳","申"]
      "巳":["申", '寅']
      "申":["寅","巳"]
      "丑":["戌","未"]
      "戌":["未","丑"]
      "未":["戌","丑"]
    }


  ###
    获取三会或者三合的五行
    @method getRule3Wuxing
    @param {string} dizhi 地支
    @return {string} 五行
  ###
  getRule3Wuxing: (dizhi, sourceList) =>
    result = ''
    _.map sourceList, (dizhiList, wuxing) =>
      containsArray = _.compact(_.map dizhiList, (dizhiListItem) => return true if dizhiListItem == dizhi)
      result = wuxing if containsArray.length > 0
    result

  ###
    三合、三会局的怕段
    @method ruleWith3Config
    @param {array} ruleList 规则表
    @param {object} result 输出对象
    @return {无} 无
  ###
  ruleWith3Config: (ruleList, result) =>
    _.map ruleList, (dizhiList, wuxing) =>
      _.map dizhiList, (dizhi) =>
        result[dizhi] = _.without dizhiList, dizhi
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
    @ruleWith3Config @huiList, @huiDizhi

  ###
    三合局的判断
    @method sanheConfig
    @return {[type]} [description]
  ###
  sanheConfig: () =>
    @sanheDizhi = {}
    @sanheList = {
      '火': ["寅","午","戌"]
      '金': ["巳","酉","丑"]
      '水': ["申","子","辰"]
      '木': ["亥","卯","未"]
    }
    @ruleWith3Config @sanheList, @sanheDizhi

  rule3: (dizhi, list, sourceList, type) =>
    if not list
      sourceList[dizhi]
    else if typeof list != 'object'
      console.log "判断#{type}时必须输入地支的数组，不能输入文字"
    else if list.length < 1
      console.log "判断#{type}时数组的长度不能小于1"
    else
       list = _.uniq list
       resultList = _.compact _.map(list, (item) => return item if _.indexOf(sourceList[dizhi], item) >-1)
       if resultList.length > 0
         resultList
       else
         false
  ###
    判断是输入的地支列表中是否有会的情况出现
    @method hui
    @param {string} dizhi 当前地址
    @param {array} list 输入地支列表
    @return {array|boolean} 有会，则为array，无会，则为false
  ###
  hui: (dizhi, list) =>
    @rule3 dizhi, list, @huiDizhi, '地支会'

  ###
    判断是输入的地支列表中是否有会的情况出现
    @method sanhe
    @param {string} dizhi 当前地址
    @param {array} list 输入地支列表
    @return {array|boolean} 有会，则为array，无会，则为false
  ###
  sanhe: (dizhi, list) =>
    @rule3 dizhi, list, @sanheDizhi, '地支三合'

  ###
    从地支列表中，获取三合、三会信息
    @method findRule3InDizhiList
    @param {array} list 地支列表
    @param {function} func 回调方法
    @param {string} name1 三合或者三会
    @param {string} name2 半合或者半会
    @param {object} sourceList 规则数据
    @return {object} 结果对象
  ###
  findRule3InDizhiList: (list, func, name1, name2, sourceList) =>
    if typeof list!='object'
      console.log '输入必须是地支列表'
    else if list.length < 2
      console.log '输入列表的长度不能小于2'
    else
      huiArray = {}
      huiArray[name1] = []
      huiArray[name2] = []
      withoutList = []
      _.map list, (item) =>
        return if _.indexOf(withoutList, item) >-1
        withoutList.push item
        inputList = _.filter list, (i) => return true if _.indexOf(withoutList, i) == - 1
        return if inputList.length < 1
        huiResult = func item, inputList
        if huiResult
          _.map huiResult, (huiResultItem) => withoutList.push huiResultItem
          huiResult.push item
          if huiResult.length == 3
            huiArray[name1].push huiResult
          else if huiResult.length == 2
            huiArray[name2].push huiResult
      if huiArray[name1].length == 0 and huiArray[name2].length == 0
        huiArray = false
      else if huiArray[name2].length == 0
        delete huiArray[name2]
      else if huiArray[name1].length == 0
        delete huiArray[name1]
      if not huiArray
        result = false
      else
        result = {}
        _.map [name1, name2], (term) =>
          _.map huiArray[term], (huiArrayItem) =>
            wuxing = @getRule3Wuxing huiArrayItem[0], sourceList
            result[term] = {} if not result[term]
            result[term][wuxing] = huiArrayItem
      result

  ###
    从输入的地支列表中寻找会
    @method findHuiInDizhiList
    @param {array} list 地支列表
    @return {array|boolean} 没有会则为false，否则是数组
  ###
  findHuiInDizhiList: (list) =>
    @findRule3InDizhiList list, @hui, '三会','半会', @huiList

  ###
    从输入的地支列表中寻找三合
    @method findHuiInDizhiList
    @param {array} list 地支列表
    @return {array|boolean} 没有三合则为false，否则是数组
  ###
  findSanheInDizhiList: (list) =>
    @findRule3InDizhiList list, @sanhe, '三合','半合', @sanheList

  ###
    害、冲、六合的规则匹配
    @method ruleConfig
    @param {array} ruleList 规则矩阵
    @param {object} result 结果对象
    @return {无} 无
  ###
  ruleConfig: (ruleList, result) =>
    _.map ruleList, (ruleListItem) =>
      _.map ruleListItem, (ruleListItemDizhi) =>
        result[ruleListItemDizhi] = _.without(ruleListItem, ruleListItemDizhi)[0]

  ###
    配置六害
    @method haiConfig
    @param {string} dizhi 地支
    @return {无} 无
  ###
  haiConfig: () =>
    @haiDizhi = {}
    @haiList = [
      ['子','未']
      ['丑','午']
      ['戌','酉']
      ['亥','申']
      ['辰','卯']
      ['寅','巳']
    ]
    @ruleConfig @haiList, @haiDizhi

  ###
    配置六合
    @method liuheConfig
    @param {string} dizhi 地支
    @return {无} 无
  ###
  liuheConfig: () =>
    @liuheDizhi = {}
    @liuheList = [
      ['子','丑']
      ['未','午']
      ['辰','酉']
      ['巳','申']
      ['卯','戌']
      ['寅','亥']
    ]
    @ruleConfig @liuheList, @liuheDizhi

  ###
    配置六冲
    @method liuchongConfig
    @param {string} dizhi 地支
    @return {无} 无
  ###
  liuchongConfig: () =>
    @liuchongDizhi = {}
    @liuchongList = [
      ['子','午']
      ['未','丑']
      ['辰','戌']
      ['巳','亥']
      ['卯','酉']
      ['寅','申']
    ]
    @ruleConfig @liuchongList, @liuchongDizhi


  ###
    [rule description]
    @method rule
    @param {string} dizhi 地支
    @param {array} list 地支列表
    @param {array} sourceList 规则数据
    @return {object} 结果对象
  ###
  rule: (dizhi, list, sourceList) =>
    if not list
      sourceList[dizhi]
    else if typeof list!='object'
      console.log '输入的内容必须为地支列表'
    else
      if _.indexOf(list, sourceList[dizhi]) >-1 then return sourceList[dizhi] else return false

  ###
    查找对应地支的害的情况
    @method hai
    @param {string} dizhi 地支
    @param {array} list 要查询的地支数组
    @return {string|boolean} 如果没有害，则为false
  ###
  hai: (dizhi, list) =>
    @rule dizhi, list, @haiDizhi


  ###
    查找对应地址的冲的情况
    @method chong
    @param {string} dizhi 地支
    @param {array} list 要查询的地支数组
    @return {string|boolean} 如果没有冲，则为false
  ###
  chong: (dizhi, list) =>
    @rule dizhi, list, @liuchongDizhi

  ###
    查找对应地址的六合的情况
    @method liuhe
    @param {string} dizhi 地支
    @param {array} list 要查询的地支数组
    @return {string|boolean} 如果没有六合，则为false
  ###
  liuhe: (dizhi, list) =>
    @rule dizhi, list, @liuheDizhi

  ###
    查找一个地支列表中所有的六合
    @method findLiuHeInDizhiList
    @param {array} list 地支列表
    @return {array} 所有六合的列表
  ###
  findLiuHeInDizhiList: (list) =>
    @findRuleInDizhiList list, @liuhe

  ###
    查找一个地支列表中所有的冲
    @method findChongInDizhiList
    @param {array} list 地支列表
    @return {array} 所有冲的列表
  ###
  findChongInDizhiList: (list) =>
    @findRuleInDizhiList list, @chong

  ###
    查找一个地支列表中所有的害
    @method findHaiInDizhiList
    @param {array} list 地支列表
    @return {array} 所有害的列表
  ###
  findHaiInDizhiList: (list) =>
    @findRuleInDizhiList list, @hai

  ###
    查找一个地支列表中所有的规则
    @method findRuleInDizhiList
    @param {array} list 地支列表
    @return {array} 所有规则的列表
  ###
  findRuleInDizhiList: (list, func) =>
    ruleArray = []
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
        currentRuleDizhi = func item, inputList
        if currentRuleDizhi
          currentResult = [currentRuleDizhi, item]
          withoutList.push currentRuleDizhi
          ruleArray.push currentResult
    if ruleArray.length == 0
      ruleArray = false
    ruleArray

  ###
    查找与当前地支相刑的地支
    @method xing
    @param {string} dizhi 地支
    @param {array} list 地支列表
    @return {无} 无
  ###
  xing: (dizhi, list) =>
    _.filter list, (item) =>
      return true if _.indexOf(@xingDizhi[dizhi], item) >-1

  ###
    查找与当前地支相刑的地支，带方向
    @method xing
    @param {string} dizhi 地支
    @param {array} list 地支列表
    @return {无} 无
  ###
  xingWithDirection: (dizhi, list) =>
    _.filter list, (item) =>
      return true if @xingDizhiWithDirection[dizhi] == item


  ###
    在当前的地支列表里面寻找刑
    @method findXingInDizhiList
    @param {array} list 地支
    @return {object} 相刑的对象
  ###
  findXingInDizhiList: (list) =>
    xingArray = {}
    _.map list, (item, index) =>
      l = _.clone list
      _.pullAt l, index
      inputList = l
      currentXing = @xing item, inputList
      xingArray[item] = currentXing if currentXing.length
    xingArray

  ###
    在当前的地支列表里面寻找刑，带方向
    @method findXingInDizhiList
    @param {array} list 地支
    @return {object} 相刑的对象
  ###
  findXingWithDirectionInDizhiList: (list) =>
    xingArray = {}
    _.map list, (item, index) =>
      l = _.clone list
      _.pullAt l, index
      inputList = l
      currentXing = @xingWithDirection item, inputList
      xingArray[item] = currentXing if currentXing.length > 0
    xingArray

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

  ###
    地支之间的关系
    @method relations
    @param {array} list 地支列表
    @return {object} 结果对象
  ###
  relations: (list) =>
      result =
        '六合': @findLiuHeInDizhiList list
        '三合': @findSanheInDizhiList list
        '害': @findHaiInDizhiList list
        '会': @findHuiInDizhiList list
        '冲': @findChongInDizhiList list
        '刑': @findXingInDizhiList list
        '刑(带方向)': @findXingWithDirectionInDizhiList list
      _.map result, (value, key) =>
        if not value
          delete result[key]
      result

exports.Dizhi = Dizhi
