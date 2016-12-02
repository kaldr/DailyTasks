import angular from 'angular'
import angularMeteor from 'angular-meteor'
import uiRouter from 'angular-ui-router'

import templateUrl from './socially.ng.jade'
import {PartiesList} from '../partiesList/partiesList.coffee'
import {Navigation} from '../navigation/navigation.coffee'
import {PartyDetails} from "../partyDetails/partyDetails.coffee"



class Socially

name = 'socially'

config = ($locationProvider, $urlRouterProvider) ->
  'ngInject'
  $locationProvider.html5Mode true
  $urlRouterProvider.otherwise '/parties'

run = ($rootScope, $state) =>
  'ngInject'
  $rootScope.$on '$stateChangeError', (event, toState, toParams, fromState, fromParams, error) =>
    if error == 'AUTH_REQUIRED'
      $state.go 'parties'

component = angular.module name, [
  angularMeteor
  PartiesList
  Navigation
  uiRouter
  PartyDetails
  'accounts.ui'
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: Socially
  }
  .config config
  .run run
  .name

exports.Socially = component
