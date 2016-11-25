# public tools
_ = require 'lodash'
__projectPath = _.dropRight(__dirname.split('/'), 4).join "/"
moment = require 'moment'
# package tools
{Analyzer} = require __dirname + '/analyzer.coffee'
{TimeInfo} = require __projectPath + "/Util/Time/TimeInfo.coffee"

class Jobs extends Analyzer
  constructor: () ->
    super()
