{information} = require './information'

class Domain extends information
	constructor: (@dbname) ->
		super @dbname

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

exports.Domain = Domain
