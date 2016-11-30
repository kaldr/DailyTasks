{information} = require './information'
Q = require 'q'
_ = require 'lodash'
__projectPath = _.dropRight(__dirname.split('/'), 4).join "/"
{TimeInfo} = require __projectPath + "/Util/Time/TimeInfo.coffee"

class Industry extends information
	updateAnIndustryItem : (item) =>
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
	updateIndustry: () =>
    Q.all(_.keys(@databaseConfig.industry).map(@updateAnIndustryItem)).then () =>
					console.log "✅ Inserted all data to industry collection."

	updateAnIndustryDomainItem : (domain) =>
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



exports.Industry = Industry
