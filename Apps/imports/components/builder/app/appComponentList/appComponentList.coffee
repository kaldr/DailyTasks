import 'angular-ui-tree/dist/angular-ui-tree'
import 'angular-ui-tree/dist/angular-ui-tree.min.css'

import {Controller} from 'angular-ecmascript/module-helpers'
import templateUrl from './appComponentList.ng.jade'
import './appComponentList.styl'
import _ from 'lodash'

import addComponentTemplate from './addComponent.ng.jade'


class appComponentList extends Controller
  constructor: ($stateParams, $scope, $mdDialog) ->
    'ngInject'
    @appName = $stateParams.appName
    @getComponentList()
    @mdDialog = $mdDialog

  createComponent: (app, name, path) =>
    Meteor.call 'createComponent', app, name, path, (err, data) =>
      console.log data
  addComponentAction: (event, item) =>
    DialogueController = ($scope, $mdDialog) =>
      $scope.createComponent = @createComponent
      $scope.appName = @appName
      if item
        $scope.pathName = item.filePath
      else
        $scope.pathName = '/imports/components/' + @appName
      $scope.hide = () ->$mdDialog.hide()
      $scope.cancel = () ->$mdDialog.cancel()

    addComponentDialog =
      templateUrl: addComponentTemplate
      parent: angular.element document.body
      targetEvent: event
      controller: DialogueController
      clickOutsideToClose: true

    @mdDialog.show addComponentDialog


  view: (node) ->
    if not @searchComponent
      return true
    else
      @searchComponent = @searchComponent.toLowerCase()
      f = node.fileName.toLowerCase()
    if f.indexOf(@searchComponent) >-1
      return true
    else
      chldr = _.find node.children, (item) =>
        fn = item.fileName.toLowerCase()
        return fn.indexOf(@searchComponent) >-1
      if chldr
        return true
    false

  getComponentList: () =>
    b = _.find module_bootstrap.bootstrap, (item) ->return item.fileName == 'components'
    app = _.find b.children, (item) =>return item.fileName == @appName

    if app
      @bootstrap = app.children

name = 'appComponentList'

component = angular.module name, [
  'angular-meteor'
  'ngMaterial'
  'ui.router'
  'ui.tree'
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: appComponentList
  }
  .name

exports.appComponentList = component
