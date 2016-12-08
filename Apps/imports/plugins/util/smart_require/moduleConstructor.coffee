import {Meteor} from 'meteor/meteor'

require './helpers.coffee'
fs = require 'fs'
path = require 'path'
_ = require 'lodash'
season = require 'season'

basePath = path.resolve('.').split('.meteor')[0]
importsPath = basePath + 'imports/'
componentPath = importsPath + 'components'
apiPath = importsPath + 'api'
configsPath = importsPath + "configs"
framework = fs.readdirSync(importsPath)

_framework_modules = {}

build_framework_modules = (fileInfo) ->
  if fileInfo.fileType == 'coffee'
    _framework_modules[fileInfo.folderType] = {} if not _framework_modules[fileInfo.folderType]
    if _framework_modules[fileInfo.folderType][fileInfo.moduleName]
      _framework_modules[fileInfo.folderType][fileInfo.moduleName].push fileInfo
    else
      _framework_modules[fileInfo.folderType][fileInfo.moduleName] = [fileInfo]

_framework_bootstrap = framework.map (item) -> dirTree(importsPath + item , item, build_framework_modules)

object = {
  modules: _framework_modules
  bootstrap: _framework_bootstrap
}
ostr = season.stringify object

ojsonstr = JSON.stringify object, null, 4
str = "module_bootstrap=" + ojsonstr+";export {module_bootstrap};"
fs.truncateSync configsPath + "/bootstrap.js"
fs.writeFileSync configsPath + "/bootstrap.js", str, {flag: 'w'}

export {_framework_modules, _framework_bootstrap}
