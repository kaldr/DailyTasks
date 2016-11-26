CSON = require 'cson'
_ = require 'lodash'
MongoClient = require 'mongojs'
ObjectId = MongoClient.ObjectId

Segment = require 'segment'

class analyzer
  #=======================================================================================
  #构造方法与初始化方法
  #=======================================================================================
  constructor: (@name) ->
    @initialize()
    @connectDB()

  ###
    初始化方法
    @method initialize
    @return {无} 无
  ###
  initialize: () =>
    #初始化变量
    @initializedDefaultSegemnt = false
    #全局配置
    @globalConfig = CSON.load __dirname + "/config.cson"
    #初始化segment分词工具
    @initializeSegment()

  ###
    初始化segment
    @method initializeSegment
    @return {无} 无
  ###
  initializeSegment: () =>
    @segment = new Segment()
    @segment.useDefault() if not @initializedDefaultSegemnt
    @segment.loadStopwordDict 'stopword.txt'
    @initializedDefaultSegemnt = true

  ###
    链接MongoDB，建立的是长连接，只有触发断开连接才会关闭
    @method connectDB
    @return {[type]} [description]
  ###
  connectDB: () ->
    mongo = 'mongodb://' + @globalConfig.db.username + ":"+@globalConfig.db.password+"@"+ @globalConfig.db.ip + ":" + @globalConfig.db.port+"/" + @globalConfig.db.db+"?authSource=admin"
    console.log "Connecting to mongodb " + mongo + " ..."
    @db = MongoClient mongo


  #=======================================================================================
  #解析方法
  #=======================================================================================
  ###
    解析关键词，输入一段字符串，返回这个字符串的分词结果
    @method analyseKeywords
    @param {string} text 输入字符串
    @param {Boolean} forbidStopWord 是否排除stopword
    @return {Array} 输出字符串所包含的关键词
  ###
  analyseKeywords: (text, forbidStopWord) =>
    keywords = @segment.doSegment text, {
      simple: true
      stripStopword: forbidStopWord
      stripPunctuation: true
    }
    return keywords

exports.Analyzer = analyzer
