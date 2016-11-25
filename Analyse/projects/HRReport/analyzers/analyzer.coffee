CSON = require 'cson'
_ = require 'lodash'
MongoClient = require 'mongojs'
ObjectId = MongoClient.ObjectId


class analyzer
  constructor: (@name) ->
    @globalConfig = CSON.load __dirname + "/config.cson"
    @connectDB()

  ###
    链接MongoDB
    @method connectDB
    @return {[type]} [description]
  ###
  connectDB: () ->
    mongo = 'mongodb://' + @globalConfig.db.username + ":"+@globalConfig.db.password+"@"+ @globalConfig.db.ip + ":" + @globalConfig.db.port+"/" + @globalConfig.db.db+"?authSource=admin"
    console.log "Connecting to mongodb " + mongo + " ..."
    @db = MongoClient mongo


exports.Analyzer = analyzer
