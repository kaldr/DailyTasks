_ = require 'lodash'
import {module_bootstrap} from '/imports/configs/bootstrap.js'
@module_bootstrap = module_bootstrap
exportsOb = {}

_.map module_bootstrap.modules, (folderInfo, folderName) ->
  moduleName = 'require_' + folderName
  @[moduleName] = (arg1, arg2, arg3) ->console.log folderInfo[name]

@angular = require 'angular'
@angularMeteor = require 'angular-meteor'
@Meteor = require 'meteor/meteor'
@uiRouter = require 'angular-ui-router'
@angularMaterial = require 'angular-material'

module.exports = exportsOb
