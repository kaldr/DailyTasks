CSON = require 'cson'
fs = require 'fs'
request = require 'request'
_ = require 'lodash'
MongoClient = require 'mongodb'
  .MongoClient

#basic spider class
class spider
  constructor: (@name) ->
    @getingCookie = true
    @basicPath = './Analyse/projects/HRReport/'
    @globalConfig = CSON.load __dirname + '/config.cson'
    @config = @globalConfig[@name]
    @config.outputFolder = __dirname + '/../output/'+@name+"/"
    @connectDB()
    @getCookie()
    @taskID = new Date().getTime()

  constructGetUrl: (url, parameters) ->
    url += '?'
    _.forEach parameters, (value, key) ->
      url += key + "="+value+"&"
    url

  ###
    链接数据库
    @method connectDB
    @return {[type]} [description]
  ###
  connectDB: () ->
    mongo = 'mongodb://' + @globalConfig.db.username + ":"+@globalConfig.db.password+"@"+ @globalConfig.db.ip + ":" + @globalConfig.db.port+"/" + @globalConfig.db.db+"?authSource=admin"
    console.log "Connecting to mongodb " + mongo + " ..."
    MongoClient.connect mongo, (err, db) =>
      @db = db

  ###
    获取cookie
    @method getCookie
    @return {[type]} [description]
  ###
  getCookie: () =>
    console.log "Getting cookie from site "+@config.requestOptions.headers.Referer+" ..."
    request.get @config.requestOptions.headers.Referer
      .on 'response', (response) =>
        @cookie = response.headers['set-cookie']
        @config.requestOptions.headers.Cookie = response.headers['set-cookie']
        console.log "Starting crawling for site " + @name + "..."
        @start()

exports.spider = spider
