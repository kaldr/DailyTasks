import {BuilderDashboard} from './dashboard/dashboard.coffee'
import {BuilderApp} from './app/app.coffee'
import templateUrl from './main.ng.jade'
import builderConfig from './config/config.coffee'
import './main.styl'


class builder
  constructor: ($reactive, $scope) ->
    'ngInject'



name = 'builder'

#配置
config = ($stateProvider) ->
  'ngInject'
  $stateProvider
    .state "builder.dashboard", {
      url: "/dashboard"
      parent: "builder"
      views:
        builder:
          template: "<builder-dashboard flex='100' layout='row' layout-align='center'></builder-dashboard>"
    }
    .state 'builder.app', {
      url: "/app"
      parent: "builder"
      views:
        builder:
          template: "<builder-app flex='100' layout='row' layout-align='center'></builder-app>"
    }
    .state "builder.config", {
      url: "/config"
      parent: "builder"
      views:
        builder:
          template: "<builder-config></builder-config>"
    }
    .state 'builder.api', {
      url: "/api"
      parent: "builder"
      views:
        builder:
          template: "<builder-api></builder-api>"
    }

component = angular.module name, [
  'angular-meteor'
  'ui.router'
  angularMaterial
  BuilderApp
  BuilderDashboard
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: builder
  }
  .config config
  .name


exports.Builder = component
