import angular from 'angular'
import angularMeteor from 'angular-meteor'

import buttonTemplateUrl from './partyAddModal.ng.jade'
import modalTemplateUrl from './partyAddButton.ng.jade'

import {PartyAdd} from '../partyAdd/partyAdd.coffee'

class PartyAddButton
  constructor: ($mdDialog, $mdMedia) ->
    'ngInject'
    @$mdDialog = $mdDialog
    @mdMedia = $mdMedia

  open: (event) =>
    @$mdDialog.show {
      controller: ($mdDialog) =>
        'ngInject'
        @close = () =>
          $mdDialog.hide()
      controllerAs: "partyAddModal"
      templateUrl: modalTemplateUrl
      parent: angular.element document.body
      clickOutsideToClose: true
      fullscreen: @$mdMedia('sm') || @mdMedia('xs')
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
