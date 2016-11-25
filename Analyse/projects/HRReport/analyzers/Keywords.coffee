# public tools
_ = require 'lodash'
__projectPath = _.dropRight(__dirname.split('/'), 4).join "/"
moment = require 'moment'
Segment = require 'segment'


# package tools
{Analyzer} = require __dirname + '/analyzer.coffee'
{TimeInfo} = require __projectPath + "/Util/Time/TimeInfo.coffee"

class Keywords extends Analyzer
  constructor: () ->
    super()
    @initializedDefaultSegemnt = false
    @initialize()

  ###
    初始化分词工具
    @method initialize
    @return {[无]} [无]
  ###
  initialize: () =>
    @segment = new Segment()
    @segment.useDefault() if not @initializedDefaultSegemnt
    @initializedDefaultSegemnt = true

  analyseKeywords: (text) =>
    keywords = @segment.doSegment text, {simple: true}
    console.log keywords

keywords = new Keywords()
keywords.analyseKeywords '✅手机兼职试玩app【一单一结】'
