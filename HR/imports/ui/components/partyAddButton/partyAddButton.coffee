import angular from 'angular'
import angularMeteor from 'angular-meteor'

import buttonTemplateUrl from './partyAddButton.ng.jade'
import modalTemplateUrl from './partyAddModal.ng.jade'

import {PartyAdd} from '../partyAdd/partyAdd.coffee'

class PartyAddModal
  constructor: ($mdDialog) ->
    @$mdDialog = $mdDialog
  close: () =>
    @$mdDialog.hide()

class PartyAddButton
  constructor: ($mdDialog, $mdMedia) ->
    'ngInject'
    @$mdDialog = $mdDialog
    @$mdMedia = $mdMedia

  open: (event) =>
    @$mdDialog.show {
      controller: PartyAddModal
      controllerAs: "partyAddModal"
      templateUrl: modalTemplateUrl
      parent: angular.element document.body
      clickOutsideToClose: true
      fullscreen: @$mdMedia('sm') || @$mdMedia('xs')
    }

name = 'partyAddButton'
component = angular.module name, [
  angularMeteor
  PartyAdd
]
  .component name, {
    templateUrl: buttonTemplateUrl
    controllerAs: name
    controller: PartyAddButton
  }
  .name

exports.PartyAddButton = component
