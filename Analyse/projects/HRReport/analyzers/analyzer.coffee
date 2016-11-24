CSON = require 'cson'
_ = require 'lodash'
MongoClient = require 'mongodb'
  .MongoClient

class analyzer
  constructor: (@name) ->
    @globalConfig = CSON.load __dirname + "/config.cson"
    @connectDB()

  connectDB: () ->
    mongo = 'mongodb://' + @globalConfig.db.username + ":"+@globalConfig.db.password+"@"+ @globalConfig.db.ip + ":" + @globalConfig.db.port+"/" + @globalConfig.db.db+"?authSource=admin"
    console.log "Connecting to mongodb " + mongo + " ..."
    MongoClient.connect mongo, (err, db) =>
      console.log err
      console.log db
      @db = db



exports.Analyzer = analyzer
