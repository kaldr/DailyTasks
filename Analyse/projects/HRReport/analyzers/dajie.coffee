# public tools
_ = require 'lodash'
__projectPath = _.dropRight(__dirname.split('/'), 4).join "/"
moment = require 'moment'
# package tools
{Analyzer} = require __dirname + '/analyzer.coffee'
{TimeInfo} = require __projectPath + "/Util/Time/TimeInfo.coffee"

###
  大街网分析类
###
class DaJieAnalyzer extends Analyzer
  ###
    构造器
    @method constructor
    @return {[type]} [description]
  ###
  constructor: () ->
    super 'dajie'
    @tasks = []


  # TODO: 将原始数据处理成标准数据
  # TODO: 获取采集过的数据的数量


  analyseAnJobItem: () =>

  saveJobAnalyse: (jobItem) =>

  ###
    获取一次抓取任务的所有数据
    @method getTaskData
    @param {int} taskID [爬取任务ID]
    @param {Function} callback [回调方法]
    @return {[type]} [无]
  ###
  getTaskData: (taskID, callback) =>
    @db.DaJieCrawled.find {
        taskID: taskID
      } , (err, docs) =>
        console.log docs.length
        totalCount = 0
        docs.forEach (doc) =>
          doc.data.list.forEach (jobItem) =>
            console.log jobItem.jobName



  ###
    爬取任务的数量
    @method getCrawledTasks
    @param {Function} callback [description]
    @return {[type]} [description]
  ###
  getCrawledTasks: (callback) =>
    @db.DaJieCrawled.distinct 'taskID', {
      pageID: 1
    } , (err, doc) =>
      doc.forEach (time) =>
        @getTaskData time, (totalCount) =>
          @tasks.push
            TaskID: time
            TimeInfo: new TimeInfo time
            TotalCount: totalCount


  # TODO: 查看标准数据，并且查找进一步的统计方案

  getCountOfCrawledData: () =>
    @db.DaJieCrawled.findOne (err, doc) ->
      console.log doc
    @db.DaJieCrawled.count (err, count) ->
      console.log count

exports.DaJieAnalyzer = DaJieAnalyzer


dajie = new DaJieAnalyzer()
dajie.getCrawledTasks () ->console.log dajie.tasks
