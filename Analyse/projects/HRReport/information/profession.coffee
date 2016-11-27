{MongoClient} = require 'mongojs'
CSON = require 'cson'

class Profession
  constructor: () ->
    @config()
    @connectDB()

  ###
    加载配置
    @method config
    @return {[type]} [description]
  ###
  config: () =>
    @globalConfig = CSON.load __dirname + "/config.cson"

  ###
    保存初始化的岗位职业及其架构
    @method saveInitialProfession
    @return {[type]} [description]
  ###
  saveInitialProfession: () =>

  ###
    连接到mongodb
    @method connectDB
    @return {[type]} [description]
  ###
  connectDB: () ->
    mongo = 'mongodb://' + @globalConfig.db.username + ":"+@globalConfig.db.password+"@"+ @globalConfig.db.ip + ":" + @globalConfig.db.port+"/" + @globalConfig.db.db+"?authSource=admin"
    console.log "Connecting to mongodb " + mongo + " ..."
    @db = MongoClient mongo
