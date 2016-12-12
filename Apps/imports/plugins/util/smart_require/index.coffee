_ = require 'lodash'
import {module_bootstrap} from '/imports/configs/bootstrap.js'
import {dirTree, relativePath, fileFolder} from "./helpers.coffee"
@module_bootstraps =
  modules: {}
  bootstrap: {}

exportsOb = {}

rebuildFileObject = (filestr) =>
  pathStrs = filestr.split("/")
  frameworkFolder = filestr.split("/")[1]
  [..., parent, path, fileName] = filestr.split("/")
  [moduleName, fileType] = fileName.split(".")
  fileDir = "/"+_.dropRight(pathStrs).join("/")
  currentFile =
    path: path
    parent: parent
    fileName: fileName
    name: fileName
    moduleName: moduleName
    fileType: fileType
    filePath: filestr
    folderType: frameworkFolder
    type: 'file'

rebuildModules = (moduleArray) =>
    _.compact(_.map moduleArray, rebuildFileObject)

rebuildFramework = (moduleObjs, folderName) =>
    @module_bootstraps.modules[folderName] = _.mapValues moduleObjs, rebuildModules

_.map module_bootstrap, rebuildFramework

_.map @module_bootstraps.modules, (folderInfo, folderName) ->
  moduleName = 'require_' + folderName
  @[moduleName] = (arg1, arg2, arg3) ->console.log folderInfo[name]

@angular = require 'angular'
@angularMeteor = require 'angular-meteor'
@Meteor = require 'meteor/meteor'
@uiRouter = require 'angular-ui-router'
@angularMaterial = require 'angular-material'

module.exports = exportsOb
