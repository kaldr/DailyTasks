_ = require 'lodash'
__projectPath = _.dropRight(__dirname.split('/'), 4).join "/"
{TimeInfo} = require __projectPath + "/Util/Time/TimeInfo.coffee"

connect = require 'mongojs'
CSON = require 'cson'

Q = require 'q'

###
  # 处理基本信息的类
  1.导入数据库基础数据
  [1]表结构_CollectionDictionary
  [2]领域domain
  [3]行业industry
  # 用法举例：
  A = new information 'dbserver'
  A.generateBasicData true
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
    constructor: (@dbname = 'localhost') ->
        #@dbname = 'dbserver'# 'localhost' or 'dbserver'
        Q.all [
          @configuration()
          @connectDB()
        ]
          .then () =>
            console.log 'initialized'

    ###
      配置
      @method config
      @return {Object} 配置对象
    ###
    configuration: () =>
      @globalConfig = CSON.load __dirname + "/config.cson"
      @databaseConfig = CSON.load __dirname + "/database.cson"
      @config =
        db: @globalConfig.db[@dbname]
        initialData: @databaseConfig


    ###
      连接到mongodb
      @method connectDB
      @return {db} 数据库对象
    ###
    connectDB: () =>
      if @globalConfig.db[@dbname].username
        mongodb = 'mongodb://' + @globalConfig.db[@dbname].username + ":"+@globalConfig.db[@dbname].password+"@"+ @globalConfig.db[@dbname].ip + ":" + @globalConfig.db[@dbname].port+"/" + @globalConfig.db[@dbname].db+"?authSource=admin"
      else
        mongodb = 'mongodb://'+ @globalConfig.db[@dbname].ip + ":" + @globalConfig.db[@dbname].port+"/" + @globalConfig.db[@dbname].db
      console.log "Connecting to mongodb " + mongodb + " ..."
      @db = connect mongodb



    ###
      关闭数据库连接
      @method closeDB
      @return {[type]} [description]
    ###
    closeDB: () =>
      console.log "\n⏹ Closing the database"
      @db.close()

    importInfo: (type = '导入初始数据',info='通过nodeJS程序information.coffee导入') =>
      user:
        userid: '000000000000000000002192'
        username: "黄宇"
      importType: type
      importInfo: info
      importer: "NodeJS"
      system: "macOS Sierra"
      TimeInfo: new TimeInfo()




exports.information = information
