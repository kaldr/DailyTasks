{ Meteor } = require 'meteor/meteor'
import '/imports/plugins/util/smart_require/moduleConstructor.coffee'

Meteor.startup ->
  fs = require 'fs'
  path = require 'path'
  basePath = path.resolve('.').split('.meteor')[0]+'imports'
