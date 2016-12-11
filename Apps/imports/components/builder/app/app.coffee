import templateUrl from './app.ng.jade'
import './app.styl'
import {BuilderAppList} from "./appList/appList.coffee"
import {BuilderAppIntro} from "./appIntro/appIntro.coffee"
import {appComponentList} from './appComponentList/appComponentList.coffee'
class BuilderApp
  constructor: ($state) ->


  getAppComponents: () =>
  addApp: () =>
  addComponent: () =>

name = 'builderApp'

config = ($stateProvider) ->
  $stateProvider
    .state 'builder.app.detail', {
      url: '/appID/:appName'
      parent: 'builder.app'
      views:
        appcomponents:
          template: "<app-component-list></app-component-list>"
    }
    .state 'builder.app.add', {
      url: '/add'
      parent: 'builder.app'
      views:
        appcomponents:
          template: "<builder-app-add></builder-app-add>"
    }
    .state "builder.app.intro", {
      url: "/intro"
      parent: 'builder.app'
      views:
        appcomponents:
          template: "<builder-app-intro></builder-app-intro>"
    }

component = angular.module name, [
  'angular-meteor'
  BuilderAppList
  BuilderAppIntro
  appComponentList
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: BuilderApp
  }
  .config config
  .name

exports.BuilderApp = component
