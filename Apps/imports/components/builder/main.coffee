import dashboard from './dashboard/dashboard.coffee'
import {BuilderApp} from './app/app.coffee'
import templateUrl from './main.ng.jade'
import builderConfig from './config/config.coffee'

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
      url: "/builder/dashboard"
      views:
        builder:
          template: "<builder-dashboard></builder-dashboard>"
    }
    .state 'builder_app', {
      url: "/builder/app"
      views:
        builder:
          template: "<builder-app></builder-app>"
    }
    .state "builder_config", {
      url: "/builder/config"
      views:
        builder:
          template: "<builder-config></builder-config>"
    }
    .state 'builder_api', {
      url: "/builder/api"
      views:
        builder:
          template: "<builder-api></builder-api>"
    }

component = angular.module name, [
  'angular-meteor'
  'ui.router'
  angularMaterial
  BuilderApp
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: builder
  }
  .config config
  .name


exports.Builder = component
