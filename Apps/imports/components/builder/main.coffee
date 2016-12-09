import {BuilderDashboard} from './dashboard/dashboard.coffee'
import {BuilderApp} from './app/app.coffee'
import templateUrl from './main.ng.jade'
import builderConfig from './config/config.coffee'
import './main.styl'

class builder
  constructor: ($reactive, $scope) ->
    'ngInject'
    console.log "OK"

name = 'builder'

#配置
config = ($stateProvider) ->
  'ngInject'
  $stateProvider
    .state "builder_dashboard", {
      url: "/dashboard"
      parent: "builder"
      views:
        builder:
          template: "<builder-dashboard flex='100' layout='row' layout-align='center'></builder-dashboard>"
    }
    .state 'builder_app', {
      url: "/app"
      parent: "builder"
      views:
        builder:
          template: "<builder-app></builder-app>"
    }
    .state "builder_config", {
      url: "/config"
      parent: "builder"
      views:
        builder:
          template: "<builder-config></builder-config>"
    }
    .state 'builder_api', {
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
