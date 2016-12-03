import angular from 'angular'
import angularMeteor from 'angular-meteor'
import uiRouter from 'angular-ui-router'
import ngMaterial from 'angular-material'
import templateUrl from './socially.ng.jade'
import {PartiesList} from '../partiesList/partiesList.coffee'
import {Navigation} from '../navigation/navigation.coffee'
import {PartyDetails} from "../partyDetails/partyDetails.coffee"
import {Auth} from '../auth/auth.coffee'


class Socially

name = 'socially'

config = ($locationProvider, $urlRouterProvider, $mdIconProvider) ->
  'ngInject'
  $locationProvider.html5Mode true
  $urlRouterProvider.otherwise '/parties'
  iconPath = '/packages/planettraining_material-design-icons/bower_components/material-design-icons/sprites/svg-sprite/'
  $mdIconProvider
    .iconSet('social',
      iconPath + 'svg-sprite-social.svg')
    .iconSet('action',
      iconPath + 'svg-sprite-action.svg')
    .iconSet('communication',
      iconPath + 'svg-sprite-communication.svg')
    .iconSet('content',
      iconPath + 'svg-sprite-content.svg')
    .iconSet('toggle',
      iconPath + 'svg-sprite-toggle.svg')
    .iconSet('navigation',
      iconPath + 'svg-sprite-navigation.svg')
    .iconSet('image',
      iconPath + 'svg-sprite-image.svg') ;
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
  ngMaterial
  PartyDetails
  Auth
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
