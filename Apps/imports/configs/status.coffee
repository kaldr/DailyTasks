import {Meteor} from 'meteor/meteor'

if Meteor.isServer
  CSON = require 'cson'
  fs = require 'fs'
  _ = require 'lodash'
  path = require 'path'
  basePath = path.resolve('.').split('.meteor')[0]
  importsPath = basePath + 'imports/'
  componentPath = importsPath + 'components/'
  apiPath = importsPath + 'api/'
  configsPath = importsPath + "configs/"
  configs = CSON.load configsPath + "status.cson"

return_status = (type, id) ->
  _.find configs[type], (item) ->item.status == id

exports.return_status = return_status
