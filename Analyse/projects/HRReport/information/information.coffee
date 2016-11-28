_ = require 'lodash'
__projectPath = _.dropRight(__dirname.split('/'), 4).join "/"
{TimeInfo} = require __projectPath + "/Util/Time/TimeInfo.coffee"

connect = require 'mongojs'
CSON = require 'cson'

async = require 'async'
Q = require 'q'

###
  处理基本信息的类
  1.导入数据库基础数据
  [1]表结构
  [2]领域domain
  [3]行业industry

###
class information
    ###
    #===========================================================================
    构造器与初始化函数
    @method constructor 构造器
    @method connectDB 连接数据库
    @method config 初始化配置
    @method closeDB 关闭数据库
    #===========================================================================
    ###

    ###
      构造器
      @method constructor
      @return {[type]} [description]
    ###
    constructor: () ->
        @configuration()
        @connectDB()


    ###
      配置
      @method config
      @return {Object} 配置对象
    ###
    configuration: () =>
      @globalConfig = CSON.load __dirname + "/config.cson"
      @databaseConfig = CSON.load __dirname + "/database.cson"
      @config =
        db: @globalConfig.db
        initialData: @databaseConfig


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
      关闭数据库连接
      @method closeDB
      @return {[type]} [description]
    ###
    closeDB: () =>
      console.log "Closing the database"
      @db.close()


    ###
    #===========================================================================
    数据库基础数据操作
    @method updateCollectionDictionary 更新数据库的数据字典
    @method upsertCD 更新一条数据字典
    #===========================================================================
    ###
    generateBasicData: () =>
      @tasks =
        updateIndustry: false
        updateDomain: false
        updateCollectionDictionary: false


    updateDomain: () =>


    updateAnIndustryItem: (item) =>
      id = @databaseConfig.industry[item]
      type = _.find @databaseConfig.domain, (domainItem) ->
        true if _.indexOf(domainItem.data, id) >-1
      @db.industry.update {
        id: parseInt id
      } , {
        id: parseInt id
        name: item
        type: type.title.c
      } , {
        upsert: true
      }

    updateIndustry: () =>
      async.every _.keys(@databaseConfig.industry), updateAnIndustryItem, (err, items) =>
        @tasks
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

A = new information()
