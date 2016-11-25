{Connector} = require __dirname + "/connector"
{ObjectID} = require 'mongodb'
  .ObjectID

class checkOrderSourceIDPrefix
  ###*
         * 构造器
         * @method constructor
         * @return {[type]} [description]
  ###
  constructor: () ->
    @DB = new Connector()

  ###*
       * 运行
       * @method run
       * @param {Function} callback 回调方法
       * @return {class} 返回自己
  ###
  run: (callback) =>

  connect: () =>
    @DB._connect_src_db (db) =>
			col = db.collection 'DisneyTicketStock'
			col.find {
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
