(function() {
  var Connector, Importer, ObjectID,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Connector = require(__dirname + '/connector').Connector;

  ObjectID = require("mongodb").ObjectID.ObjectID;

  Importer = (function() {
    function Importer() {
      this.initializeSourceCollection = bind(this.initializeSourceCollection, this);
      this.run = bind(this.run, this);
      this.DB = new Connector();
      this.initializeSourceCollection(this.run);
    }

    Importer.prototype.run = function() {
      return this.collections.forEach((function(_this) {
        return function(data, index) {
          return _this.DB.srcDB.collection('DisneyTicketStock').findOne({
            _id: ObjectID(data._id)
          }, {
            fields: {
              orderHistory: true
            }
          }, function(err, doc) {
            var leftOrder;
            leftOrder = doc.orderHistory.length;
            console.log(leftOrder);
            return doc.orderHistory.forEach(function(order, orderindex) {
              return _this.DB.dstnDB.collection('DisneyTicketReservationHistory').update({
                _id: ObjectID(data._id)
              }, {
                $set: {
                  Status: order.Status,
                  OrderLines: order.OrderLines,
                  OrderTickets: order.OrderTickets,
                  OTAId: order.OTAId,
                  Timestamp: order.Timestamp,
                  Endorsement: order.Endorsement,
                  OrderDate: order.OrderDate,
                  VisitDate: order.VisitDate,
                  OrderID: order.OrderID,
                  SourceID: order.SourceID,
                  SessionID: order.SessionID,
                  GovermentID: order.GovermentID,
                  customer_name: order.customer_name,
                  customer_mobile: order.customer_mobile,
                  submit_username: order.submit_username,
                  submit_userid: order.submit_userid,
                  orderType: 1,
                  taID: '582e8e9bb0ae1ca5638b465e',
                  ta: {
                    _id: ObjectID('582e8e9bb0ae1ca5638b465e'),
                    name: "飞扬ERP后台"
                  },
                  purchaseStatus: {
                    type: "purchased",
                    name: "已完成采购",
                    statusID: ObjectID('582b000bb0ae1cf7268b4ca5'),
                    id: 2,
                    status: "成功",
                    info: "已经提交到迪士尼，成功订购"
                  }
                }
              }, {
                upsert: true
              }, function(err, item) {
                leftOrder -= 1;
                if (index === _this.collections.length - 1 && leftOrder === 0) {
                  _this.DB.srcDB.close();
                  _this.DB.dstnDB.close();
                  return console.log('done');
                }
              });
            });
          });
        };
      })(this));
    };

    Importer.prototype.initializeSourceCollection = function(callback) {
      return this.DB._connect_src_db((function(_this) {
        return function(db) {
          var col;
          col = db.collection('DisneyTicketStock');
          return col.find({
            count: {
              $gt: 0
            }
          }, {
            fields: {
              _id: true
            }
          }).toArray(function(err, docs) {
            _this.collections = docs;
            return _this.DB._connect_dstn_db(function() {
              return callback(db);
            });
          });
        };
      })(this));
    };

    Importer.prototype._importRecord = function() {};

    return Importer;

  })();

  new Importer();

}).call(this);
