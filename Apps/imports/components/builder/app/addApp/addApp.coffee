import templateUrl from './addApp.ng.jade'
import './addApp.styl'
import {Meteor} from 'meteor/meteor'

class BuilderAppAdd
  constructor: () ->
  saveApp: () =>
    console.log 'in call'
    Meteor.call "createApp", @appName, (err, data) =>
      console.log data

name = "builderAppAdd"

component = angular.module name, [
  'angular-meteor'
  'ui.router'
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: BuilderAppAdd
  }
  .name

exports.BuilderAppAdd = component
