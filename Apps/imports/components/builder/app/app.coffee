import templateUrl from './app.ng.jade'
import './app.styl'
import {BuilderAppList} from "./appList/appList.coffee"

class BuilderApp

  getAppComponents: () =>
  addApp: () =>
  addComponent: () =>

name = 'builderApp'
config = ($stateProvider) ->
  $stateProvider
    .state 'builder.app.add', {
      url: '/add'
      parent: 'builder_app'
      views:
        appcomponents:
          template: "<builder-app-add></builder-app-add>"
    }
component = angular.module name, [
  'angular-meteor'
  BuilderAppList
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: BuilderApp
  }
  .config config
  .name

exports.BuilderApp = component
