import templateUrl from './appList.ng.jade'
import './appList.styl'

class BuilderAppList
  constructor: () ->
    @app_bootstrap = module_bootstrap
    @getAppList()

  getAppList: () =>
    @components = _.find @app_bootstrap.bootstrap, (item) ->return (item.fileName == 'components')
    @apps = _.filter @components.children, (item) ->return item.type == 'folder'
    console.log @apps
name = 'builderAppList'

component = angular.module name, [
  'angular-meteor'
  'ui.router'
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: BuilderAppList
  }
  .name

exports.BuilderAppList = component
component
