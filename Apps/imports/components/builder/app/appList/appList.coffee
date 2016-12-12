import templateUrl from './appList.ng.jade'
import './appList.styl'
import {BuilderAppAdd} from '../addApp/addApp.coffee'

class BuilderAppList
  constructor: () ->
    @app_bootstrap = module_bootstraps
    @getAppList()

  getAppList: () =>
    @components = _.find @app_bootstrap.bootstrap, (item) ->return (item.fileName == 'components')
    @apps = _.filter @components.children, (item) ->return item.type == 'folder'

name = 'builderAppList'

component = angular.module name, [
  'angular-meteor'
  'ui.router'
  BuilderAppAdd
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: BuilderAppList
  }
  .name

exports.BuilderAppList = component
component
