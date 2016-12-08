import {Meteor} from 'meteor/meteor'
_ = require 'lodash'
import {module_bootstrap} from '/imports/configs/bootstrap.js'

_.map module_bootstrap.modules, (folderInfo, folderName) ->
  moduleName = 'require_' + folderName
  exports[moduleName] = (name) ->console.log folderInfo[name]



exports['angular'] = require 'angular'
exports.angularMeteor = require 'angular-meteor'
exports.Meteor = require 'meteor/meteor'
