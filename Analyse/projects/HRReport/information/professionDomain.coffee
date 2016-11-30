{information} = require './information'

class ProfessionDomain extends information
	construtor: (@dbname) ->
		super @dbname

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

exports.ProfessionDomain = ProfessionDomain
