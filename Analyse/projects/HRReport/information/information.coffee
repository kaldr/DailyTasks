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
    ###
    #===========================================================================
    数据库基础数据操作
    @method generateBasicData 批量完成数据库导入任务

    @method updateCollectionDictionary 更新数据库的数据字典
    @method upsertCD 更新一条数据字典

    @method updateDomain 将领域信息更新到数据库中
    @method updateAnDomainItem 更新一个领域的条目

    @method updateIndustry 更新行业
    @method updateAnIndustryItem 更新一条行业信息

    @method updateIndustryDomainItem 更新一个行业的领域信息
    @method updateAnIndustryDomainItem 更新一个领域的所有行业的领域信息

    @method updateProfession 更新岗位
    @method updateProfessionDomain 更新岗位的领域
    @method updateProfessionType 更新岗位架构
    #===========================================================================
    ###

    ###
      批量完成数据库导入任务
      @method generateBasicData
      @param {Boolean} closeDB = false 完成后是否关闭数据库
      @return {promise} promise对象
    ###
    generateBasicData: (closeDB = false) =>
      Q.all [
        @updateCollectionDictionary()
        @updateIndustry()
        @updateProfession()
      ]
        .then () =>
          Q.all [
            @updateDomain()
            @updateProfessionDomain()
            @updateProfessionType()
          ]
        .then @updateIndustryDomainItem
        .then () =>
          console.log "\n🍺 All tasks done."
          @closeDB() if closeDB

    ###
      更新一个领域的所有行业的领域信息
      @method updateAnIndustryDomainItem
      @param {Object} domain 领域信息
      @return {promise} promise对象
    ###
    updateAnIndustryDomainItem: (domain) =>
      deferred = Q.defer()
      @db.industry.update {
        type: domain.name
      } , {
        $set:
          typeID: domain._id
      } , {
        multi: true
      } , (err, doc) =>
        #console.log "完成领域：" + domain.name
        deferred.resolve()
      deferred.promise

    ###
      更新一个行业的领域信息
      @method updateIndustryDomainItem
      @param {Object} item 领域信息对象
      @return {promise} promise对象
    ###
    updateIndustryDomainItem: () =>
      defer = Q.defer()
      domain = @db.collection "domain"
      domain.find {} , {
        name: 1
        _id: 1
      } , (err, docs) =>
        Q.all(docs.map @updateAnIndustryDomainItem)
          .then () =>
            console.log "✅ Updated all industry domain items."
            defer.resolve()
      defer.promise

    ###
      更新一个领域的条目
      @method updateAnDomainItem
      @param {Object} item 完整的领域条目信息
      @return {promise} promise对象
    ###
    updateAnDomainItem: (item) =>
      deferred = Q.defer()
      industryIDList = []
      _.forEach item.data, (id) ->
        industryIDList.push {
          id: parseInt id
        }
      @db.industry.find {
        $or: industryIDList
      } , (err, docs) =>
        @db.domain.update {
          name: item.title.c
        } , {
          $set:
            name: item.title.c
            industryList: docs
          $push:
            importInfo : @importInfo()
        } , {
          upsert: true
        } , (err, docs) =>
          deferred.resolve()
      deferred.promise

    ###
      将领域信息更新到数据库中
      @method updateDomain
      @return {promise} promise对象
    ###
    updateDomain: () =>
      Q.all @databaseConfig.domain.map @updateAnDomainItem
        .then () =>
          console.log "✅ Inserted all data to domain collection."

    ###
      更新一条行业信息
      @method updateAnIndustryItem
      @param {String} item 行业ID
      @return {无} 无
    ###
    updateAnIndustryItem: (item) =>
      deferred = Q.defer()
      name = @databaseConfig.industry[item]
      type = _.find @databaseConfig.domain, (domainItem) ->
        return true if _.indexOf(domainItem.data, item) >-1
      industry = @db.collection 'industry'
      industry.update {
        id: parseInt item
      } , {
        $set:
          id: parseInt item
          name: name
          type: type.title.c
        $push:
          importInfo : @importInfo()
      } , {
        upsert: true
      } , (err, res) =>
        deferred.resolve()
      deferred.promise

    ###
      更新行业
      @method updateIndustry
      @return {无} 无
    ###
    updateIndustry: () =>
      Q.all _.keys(@databaseConfig.industry).map @updateAnIndustryItem
        .then () =>
          console.log "✅ Inserted all data to industry collection."

    ###
      插入一条表注释
      @method upsertCD
      @param {String} collectionName 表名
      @param {Function} callback 回调方法
      @return {String} 执行结果
    ###
    upsertCD : (collectionName, callback) =>
      deferred = Q.defer()
      _CollectionDictionary = @db.collection '_CollectionDictionary'
      @collectionDictionary[collectionName].importInfo = @importInfo()
      #更新数据
      _CollectionDictionary.update {
                collectionName: collectionName
            } , @collectionDictionary[collectionName], {
                upsert: true
            } , (err, doc) =>
                deferred.resolve()
      deferred.promise

    ###
      更新数据字典
      @method updateCollectionDictionary
      @return {Object} 数据字典
    ###
    updateCollectionDictionary: (callback) =>
        @collectionDictionary = @databaseConfig.collectionDictionary
        Q.all _.keys(@collectionDictionary).map @upsertCD
          .then (err, items) =>
            console.log "✅ Inserted all data to _CollectionDictionary collection."

    ###
      更新岗位
      @method updateProfession
      @return {promise} promise对象
    ###
    updateProfession: () =>
      ###
        更新一条岗位信息
        @method updateAnProfession
        @param {String} name 岗位名称
        @param {String} id 岗位id
        @return {promise} Promise对象
      ###
      updateAnProfession = (name, id) =>
        defer = Q.defer()
        @db.profession.update {
          id: parseInt id
        } , {
          $set:
            id: parseInt id
            name: name
          $push:
            importInfo: @importInfo()
        } , {
          upsert: true
        } , (err, doc) =>
          defer.resolve()
        defer.promise

      #并行执行
      Q.all _.map @databaseConfig.profession, updateAnProfession
        .then () =>console.log '✅ Inserted all data to profession collection.'

    updateProfessionType: () =>
      updateAnProfessionType = (ids, id) =>
        defer = Q.defer()
        idList = ids.split ','
          .map (id) =>{id: parseInt id}
        idList.push
          id: parseInt id
        @db.profession.find {
          $or: idList
        } , {
          _id: 1
          id: 1
          name: 1
          domain: 1
        } , (err, docs) =>
          currentPrefession = _.find docs, (doc) =>
            return true if doc.id == parseInt id
          @db.profession.findAndModify {
            query:
              _id: connect.ObjectId currentPrefession._id
            update:
              $set:
                children: docs
          } , (err, res) =>
            bulk = @db.profession.initializeOrderedBulkOp()
            addBulkUpdate = (doc) =>
              bulk.find {
                _id: connect.ObjectId doc._id
              }
                .update {
                  $set:
                    parent: currentPrefession
                }
            docs.map addBulkUpdate
            bulk.execute () =>
              defer.resolve()
        defer.promise

      Q.all _.map @databaseConfig.professionStructure, updateAnProfessionType
        .then () =>
          console.log '✅ Updated all profession types to profession collection.'


    updateProfessionDomain: () =>
      updateAnProfessionDomainItem = (item) =>
        defer = Q.defer()
        professionList = item.data.map (id) =>{id: parseInt id}
        @db.profession.find {
          $or: professionList
        } , {
          id: 1
          _id: 1
          name: 1
        } , (err, docs) =>
          @db.professionDomain.findAndModify {
            query:
              name: item.title.c
            update:
              $set:
                name: item.title.c
                prefessionList: docs
            sort:
              _id: 1
            upsert: true
            new: true
          } , (err, res) =>
            professionDomainID = connect.ObjectId res._id
            bulk = @db.profession.initializeOrderedBulkOp()
            addBulkUpdate = (doc) =>
              bulk.find {
                _id: connect.ObjectId doc._id
                }
                .update {
                  $set:
                    domain:
                      id: professionDomainID
                      name: res.name
                  $push:
                    importInfo: @importInfo('更新','追加professionDomain')
                }
            docs.forEach addBulkUpdate
            bulk.execute (err, res) =>
              defer.resolve()
        defer.promise

      Q.all _.map @databaseConfig.professionDomain, updateAnProfessionDomainItem
        .then () =>
          console.log '✅ Inserted all data to professionDomain collection.'
