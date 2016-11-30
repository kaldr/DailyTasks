{information} = require './information'
Q = require 'q'
_ = require 'lodash'
__projectPath = _.dropRight(__dirname.split('/'), 4).join "/"
{TimeInfo} = require __projectPath + "/Util/Time/TimeInfo.coffee"
connect = require 'mongojs'
class Profession extends information
  ###
    更新岗位
    @method updateProfession
    @return {promise} promise对象
  ###
  updateProfession: () =>
    ###
      更新一条岗位信息
      @method updateAnProfession
      @param {String} name 岗位名称
      @param {String} id 岗位id
      @return {promise} Promise对象
    ###
    updateAnProfession = (name, id) =>
      defer = Q.defer()
      @db.profession.update {
        id: parseInt id
      } , {
        $set:
          id: parseInt id
          name: name
        $push:
          importInfo: @importInfo()
      } , {
        upsert: true
      } , (err, doc) =>
        defer.resolve()
      defer.promise

    #并行执行
    Q.all _.map @databaseConfig.profession, updateAnProfession
      .then () =>console.log '✅ Inserted all data to profession collection.'

  updateProfessionType: () =>
    updateAnProfessionType = (ids, id) =>
      defer = Q.defer()
      idList = ids.split ','
        .map (id) =>{id: parseInt id}
      idList.push
        id: parseInt id
      @db.profession.find {
        $or: idList
      } , {
        _id: 1
        id: 1
        name: 1
        domain: 1
      } , (err, docs) =>
        currentPrefession = _.find docs, (doc) =>
          return true if doc.id == parseInt id
        @db.profession.findAndModify {
          query:
            _id: connect.ObjectId currentPrefession._id
          update:
            $set:
              children: docs
        } , (err, res) =>
          bulk = @db.profession.initializeOrderedBulkOp()
          addBulkUpdate = (doc) =>
            bulk.find {
              _id: connect.ObjectId doc._id
            }
              .update {
                $set:
                  parent: currentPrefession
                  domain: currentPrefession.domain
              }
          docs.map addBulkUpdate
          bulk.execute () =>
            defer.resolve()
      defer.promise

    Q.all _.map @databaseConfig.professionStructure, updateAnProfessionType
      .then () =>
        console.log '✅ Updated all profession types to profession collection.'

exports.Profession = Profession
