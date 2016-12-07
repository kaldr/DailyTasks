{ Meteor } = require 'meteor/meteor'

Meteor.startup ->
  fs = require 'fs'
  path = require 'path'
  basePath = path.resolve('.').split('.meteor')[0]+'imports'
  fs.readdir basePath, (err, files) =>
    console.error err
    console.log files
