CSON = require 'cson'
fs = require 'fs'
_ = require 'lodash'
MongoClient = require 'mongodb'
  .MongoClient


class Connector
  constructor: () ->
    @_config()

  ###*
     * 配置方法
     * @method _config
     * @return {无} 无
  ###

  _config: () =>
    @dbConfig = CSON.load __dirname + '/../db.cson'

  ###*
      * 连接到源数据的数据库
      * @method _connect_src_db
      * @param {Function} callback 回调方法
      * @return {[type]} [description]
  ###

  _connect_src_db: (callback) =>
    #connect to source db
    sourceMongo = 'mongodb://' + @dbConfig.source.db.username + ":"+@dbConfig.source.db.password+"@"+ @dbConfig.source.db.ip + ":" + @dbConfig.source.db.port+"/" + @dbConfig.source.db.db+"?authSource=admin"
    console.log "Connecting to source mongodb " + sourceMongo + " ..."
    MongoClient.connect sourceMongo, (err, db) =>
      @srcDB = db
      callback db

  _connect_dstn_db: (callback) =>
    #connect to destination db
    desMongo = 'mongodb://' + @dbConfig.destination.db.username + ":"+@dbConfig.destination.db.password+"@"+ @dbConfig.destination.db.ip + ":" + @dbConfig.destination.db.port+"/" + @dbConfig.destination.db.db+"?authSource=admin"
    console.log "Connecting to destination mongodb " + desMongo + " ..."
    MongoClient.connect desMongo, (err, db) =>
      @dstnDB = db
      callback db

exports.Connector = Connector
