(function() {
  var CSON, Connector, MongoClient, _, fs,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  CSON = require('cson');

  fs = require('fs');

  _ = require('lodash');

  MongoClient = require('mongodb').MongoClient;

  Connector = (function() {
    function Connector() {
      this._connect_dstn_db = bind(this._connect_dstn_db, this);
      this._connect_src_db = bind(this._connect_src_db, this);
      this._config = bind(this._config, this);
      this._config();
    }


    /**
       * 配置方法
       * @method _config
       * @return {无} 无
     */

    Connector.prototype._config = function() {
      return this.dbConfig = CSON.load(__dirname + '/../db.cson');
    };


    /**
        * 连接到源数据的数据库
        * @method _connect_src_db
        * @param {Function} callback 回调方法
        * @return {[type]} [description]
     */

    Connector.prototype._connect_src_db = function(callback) {
      var sourceMongo;
      sourceMongo = 'mongodb://' + this.dbConfig.source.db.username + ":" + this.dbConfig.source.db.password + "@" + this.dbConfig.source.db.ip + ":" + this.dbConfig.source.db.port + "/" + this.dbConfig.source.db.db + "?authSource=admin";
      console.log("Connecting to source mongodb " + sourceMongo + " ...");
      return MongoClient.connect(sourceMongo, (function(_this) {
        return function(err, db) {
          _this.srcDB = db;
          return callback(db);
        };
      })(this));
    };

    Connector.prototype._connect_dstn_db = function(callback) {
      var desMongo;
      desMongo = 'mongodb://' + this.dbConfig.destination.db.username + ":" + this.dbConfig.destination.db.password + "@" + this.dbConfig.destination.db.ip + ":" + this.dbConfig.destination.db.port + "/" + this.dbConfig.destination.db.db + "?authSource=admin";
      console.log("Connecting to destination mongodb " + desMongo + " ...");
      return MongoClient.connect(desMongo, (function(_this) {
        return function(err, db) {
          _this.dstnDB = db;
          return callback(db);
        };
      })(this));
    };

    return Connector;

  })();

  exports.Connector = Connector;

}).call(this);
