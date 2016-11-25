moment = require 'moment'
{Connector} = require __dirname + '/connector'
{ObjectID} = require "mongodb"
	.ObjectID


class Importer
	#初始化
	constructor: () ->
		@DB = new Connector()
		@initializeSourceCollection @run

	###*
	 运行
	 @method run
	 @return {[type]} [description]
	###
	run: () =>
		yaoChuFaOrderCount = 0
		erpCount = 0
		otherCount = 0
		importCount = 0
		@collections.forEach (data, index) =>
			@DB.srcDB.collection 'DisneyTicketStock'
				.findOne {
					_id: ObjectID data._id
					} , {
					fields:
						orderHistory: true
						VisitDate: true
					} ,
					(err, doc) =>
						leftOrder = doc.orderHistory.length
						#console.log "当前日期为"+doc.VisitDate+"，所有订单数量为" + leftOrder+"..."
						doc.orderHistory.forEach (order, orderindex) =>
							if not order.importLog?
								order.importLog = []

							if order.Endorsement.indexOf('IDNML') >= 0
								order.taID = '582e8e9bb0ae1ca5638b465e'
								order.orderType = 1
								order.ta =
									_id: ObjectID '582e8e9bb0ae1ca5638b465e'
									name: "飞扬ERP后台"
								erpCount++
							#如果是批量导入的内容
							else if order.Endorsement.indexOf('IDTAEBR') >= 0
								order.taID = '5825b4e3869555794234aa1a'
								order.orderType = 2
								order.ta =
									_id: ObjectID '5825b4e3869555794234aa1a'
									name: "要出发"
								yaoChuFaOrderCount++
							else if order.Endorsement.indexOf("WEB") >= 0
								order.taID = '582e8e9bb0ae1ca5638b465d'
								order.orderType = 4
								order.ta =
									_id: ObjectID '582e8e9bb0ae1ca5638b465d'
									name: "飞扬web网站"

							order.TimeInfo =
								timestamp: parseInt moment(order.Timestamp).format 'X'
								date: parseInt moment(order.Timestamp).format "YYYY-MM-DD"
								dayOfWeek: parseInt moment(order.Timestamp).format "E"
								weekOfYear: parseInt moment(order.Timestamp).format "w"
								year: parseInt moment(order.Timestamp).format "YYYY"
								month: parseInt moment(order.Timestamp).format "M"
								dayOfMonth: parseInt moment(order.Timestamp).format "D"

							order.importLog.push
								user:
									userid: '000000000000000000002192'
									username: "黄宇"
								importType: '新表'
								importInfo: '通过nodeJS批量导入订单，将原始的DisneyTicketStock表中的orderHistory全部导入到新的表中，抛弃原来的数据'
								importer: "NodeJS"
								system: "macOS Sierra"
								timestamp: parseInt moment().format 'X'
								date: parseInt moment().format "YYYY-MM-DD"
								dayOfWeek: parseInt moment().format "E"
								weekOfYear: parseInt moment().format "w"
								year: parseInt moment().format "YYYY"
								month: parseInt moment().format "M"
								dayOfMonth: parseInt moment().format "D"

							order.purchaseStatus =
								type: "purchased"
								name: "已完成采购"
								statusID: ObjectID '582b000bb0ae1cf7268b4ca5'
								id: 2
								status: "成功"
								info: "已经提交到迪士尼，成功订购"

							@DB.dstnDB.collection 'DisneyTicketReservationHistory'#'DisneyTicketReservationHistory'DisneyTicketReservationHistoryWithoutBEI
								.update {
									OrderID: order.OrderID
									} , {
									$set:
										order
									} , {
									upsert: true
									} ,
									(err, item) =>
										leftOrder -= 1
										if index == @collections.length - 1 and leftOrder == 0
											@DB.srcDB.close()
											@DB.dstnDB.close()
											console.log 'done'
											console.log "要出发订单数量：" + yaoChuFaOrderCount
											console.log 'ERP的订单数量：' + erpCount

	#将每个数据导入到新的数据库

	#初始化数据源的数据集合
	initializeSourceCollection: (callback) =>
		@DB._connect_src_db (db) =>
			col = db.collection 'DisneyTicketStock'
			col.find {
				#VisitDate: '2016-11-16'
				count:
					$gt: 0
				} , {
					fields:
						_id: true
				}
				.toArray (err, docs) =>
					@collections = docs
					@DB._connect_dstn_db () =>
						callback db
	#导入一次记录
	_importRecord: () ->

new Importer()
