import templateUrl from './addApp.ng.jade'
import './addApp.styl'
import {Meteor} from 'meteor/meteor'
import addSuccess from './addSuccess.ng.jade'
import addError from './addError.ng.jade'
import {Controller} from 'angular-ecmascript/module-helpers'
import 'angular-ui-keypress'


class BuilderAppAdd
  constructor: ($mdDialog, $scope, $reactive) ->
    'ngInject'
    $reactive this
      .attach $scope
    @$scope = $scope
    @createStatus = false
    @$mdDialog = $mdDialog

  clear: () =>
    @appName = ''

  saveApp: (event) =>
    if @appName
      @createStatus = 'loading'
      Meteor.call "createApp", @appName, (err, data) =>
        @createStatus = data.status
        @createInfo = data
        @showSaveDialogue event, @createInfo.type, @createInfo
        @clear()

  showSaveDialogue: (event, type, info) =>
    DialogController = ($scope, $mdDialog) =>
        $scope.hide = () ->$mdDialog.hide()
        $scope.cancel = () ->$mdDialog.cancel()
        $scope.info = info

    error =
      templateUrl: addError
      parent: angular.element document.body
      targetEvent: event
      controller: DialogController
      clickOutsideToClose: true

    success =
      templateUrl: addSuccess
      parent: angular.element document.body
      targetEvent: event
      controller: DialogController
      clickOutsideToClose: true

    if type == 'success' then @$mdDialog.show success else @$mdDialog.show error


name = "builderAppAdd"

component = angular.module name, [
  'angular-meteor'
  'ui.router'
  'ngMaterial'
  'ui.keypress'
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: BuilderAppAdd
  }
  .name

exports.BuilderAppAdd = component
