connect = require 'mongojs'
CSON = require 'cson'
async = require 'async'
_ = require 'lodash'
sync = require 'synchronize'
__projectPath = _.dropRight(__dirname.split('/'), 4).join "/"
{TimeInfo} = require __projectPath + "/Util/Time/TimeInfo.coffee"

class information
    constructor: () ->
        @globalConfig = CSON.load __dirname + "/config.cson"
        @databaseConfig = CSON.load __dirname + "/database.cson"
        @connectDB()
    ###
      连接到mongodb
      @method connectDB
      @return {db} 数据库对象
    ###
    connectDB: (callback) =>
      mongodb = 'mongodb://' + @globalConfig.db.username + ":"+@globalConfig.db.password+"@"+ @globalConfig.db.ip + ":" + @globalConfig.db.port+"/" + @globalConfig.db.db+"?authSource=admin"
      console.log "Connecting to mongodb " + mongodb + " ..."
      @db = connect mongodb
      callback? null, 'connected to mongodb'

    ###
      插入一条表注释
      @method upsertCD
      @param {String} collectionName 表名
      @param {Function} callback 回调方法
      @return {String} 执行结果
    ###
    upsertCD : (collectionName, callback) =>
      _CollectionDictionary = @db.collection '_CollectionDictionary'
      @collectionDictionary[collectionName].importInfo =
            user:
              userid: '000000000000000000002192'
              username: "黄宇"
            importType: '导入初始数据'
            importInfo: '通过nodeJS程序information.coffee导入'
            importer: "NodeJS"
            system: "macOS Sierra"
            TimeInfo: new TimeInfo()
      #更新数据
      _CollectionDictionary.update {
                collectionName: collectionName
            } , @collectionDictionary[collectionName], {
                upsert: true
            } , (err, doc) =>
                callback err, collectionName
    ###
      更新数据字典
      @method updateCollectionDictionary
      @return {Object} 数据字典
    ###
    updateCollectionDictionary: (callback) =>
        @collectionDictionary = @databaseConfig.collectionDictionary
        console.log "Starting..."
        async.every _.keys(@collectionDictionary), @upsertCD, (err, items) =>
          callback? err, 'updateCollectionDictionary finished'
          console.log "Done"
    ###
      关闭数据库连接
      @method closeDB
      @return {[type]} [description]
    ###
    closeDB: () =>
      console.log "Closing the database"
      @db.close()
A = new information()
A.updateCollectionDictionary()
A.close()
