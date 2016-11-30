{information} = require './information'

class CollectionDictionary extends information
	constructor: (@dbname) ->
		super @dbname


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

exports.CollectionDictionary = CollectionDictionary
