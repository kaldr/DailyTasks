{information} = require './information'
Q = require 'q'
_ = require 'lodash'
__projectPath = _.dropRight(__dirname.split('/'), 4).join "/"
{TimeInfo} = require __projectPath + "/Util/Time/TimeInfo.coffee"
connect = require 'mongojs'

class Domain extends information

	updateAnDomainItem : (item) =>
		deferred = Q.defer()
		industryIDList = []
		item.data.map (id) ->industryIDList.push {id: parseInt id}
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

	updateDomain: () =>
		Q.all(@databaseConfig.domain.map(@updateAnDomainItem))
			.then () =>
					console.log "✅ Inserted all data to domain collection."

exports.Domain = Domain
