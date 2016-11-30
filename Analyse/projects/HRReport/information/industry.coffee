{information} = require './information'

class Industry extends information
	constructor: (@dbname) ->
		super @dbname

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

exports.Industry = Industry
