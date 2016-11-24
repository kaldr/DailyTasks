{Connector} = require __dirname + '/connector'
{ObjectID} = require "mongodb"
  .ObjectID
class Importer
  #初始化
  constructor: () ->
    @DB = new Connector()
    @initializeSourceCollection @run

  ###*
                             * 运行
                             * @method run
                             * @return {[type]} [description]
  ###
  run: () =>
    yaoChuFaOrderCount = 0
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
              console.log "当前日期为"+doc.VisitDate+"，所有订单数量为" + leftOrder+"..."
              doc.orderHistory.forEach (order, orderindex) =>
                if order.taID == '5825b4e3869555794234aa1a'
                  yaoChuFaOrderCount++
                  leftOrder -= 1
                  return
                else if order.ta == undefined
                  importCount++
                  order.orderImportType = "nodeJS批量导入"
                  order.orderType = 1
                  order.taID = '582e8e9bb0ae1ca5638b465e'
                  order.ta =
                    _id: ObjectID '582e8e9bb0ae1ca5638b465e'
                    name: "飞扬ERP后台"
                  order.purchaseStatus =
                    type: "purchased"
                    name: "已完成采购"
                    statusID: ObjectID '582b000bb0ae1cf7268b4ca5'
                    id: 2
                    status: "成功"
                    info: "已经提交到迪士尼，成功订购"
                  @DB.dstnDB.collection 'DisneyTicketReservationHistory_copy'#'DisneyTicketReservationHistory'DisneyTicketReservationHistoryWithoutBEI
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
                          console.log '已导入的订单数量：' + importCount

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
