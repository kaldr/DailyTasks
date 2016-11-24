{Connector} = require __dirname + '/connector'
{ObjectID} = require "mongodb"
  .ObjectID
class Importer
  #初始化
  constructor: () ->
    @DB = new Connector()
    @initializeSourceCollection @run

  #运行
  run: () =>
    @collections.forEach (data, index) =>
        @DB.srcDB.collection 'DisneyTicketStock'
          .findOne {
            _id: ObjectID data._id
            } , {
            fields:
              orderHistory: true
            } ,
            (err, doc) =>
              leftOrder = doc.orderHistory.length
              console.log leftOrder
              doc.orderHistory.forEach (order, orderindex) =>
                @DB.dstnDB.collection 'DisneyTicketReservationHistory'
                  .update {
                    _id: ObjectID data._id
                    } , {
                    $set:
                      Status: order.Status
                      OrderLines: order.OrderLines
                      OrderTickets: order.OrderTickets
                      OTAId: order.OTAId
                      Timestamp: order.Timestamp
                      Endorsement: order.Endorsement
                      OrderDate: order.OrderDate
                      VisitDate: order.VisitDate
                      OrderID: order.OrderID
                      SourceID: order.SourceID
                      SessionID: order.SessionID
                      GovermentID: order.GovermentID
                      customer_name: order.customer_name
                      customer_mobile: order.customer_mobile
                      submit_username: order.submit_username
                      submit_userid: order.submit_userid
                      orderType: 1
                      taID: '582e8e9bb0ae1ca5638b465e'
                      ta:
                        _id: ObjectID '582e8e9bb0ae1ca5638b465e'
                        name: "飞扬ERP后台"
                      purchaseStatus:
                        type: "purchased"
                        name: "已完成采购"
                        statusID: ObjectID '582b000bb0ae1cf7268b4ca5'
                        id: 2
                        status: "成功"
                        info: "已经提交到迪士尼，成功订购"

                    } , {
                    upsert: true
                    } ,
                    (err, item) =>
                      leftOrder -= 1
                      if index == @collections.length - 1 and leftOrder == 0
                        @DB.srcDB.close()
                        @DB.dstnDB.close()
                        console.log 'done'

  #将每个数据导入到新的数据库

  #初始化数据源的数据集合
  initializeSourceCollection: (callback) =>
      @DB._connect_src_db (db) =>
        col = db.collection 'DisneyTicketStock'
        col.find
          count:
            $gt: 0
         ,
          fields:
            _id: true
         .toArray (err, docs) =>
           @collections = docs
           @DB._connect_dstn_db () =>
             callback db
  #导入一次记录
  _importRecord: () ->

new Importer()
