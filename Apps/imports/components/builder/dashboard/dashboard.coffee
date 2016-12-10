import templateUrl from './dashboard.ng.jade'
import './dashboard.styl'
import _ from 'lodash'

class BuilderDashboard
  constructor: ($scope, $rootScope) ->
    'ngInject'
    @app_bootstrap = module_bootstrap
    @getApps()
    @getApis()
    @getConfigs()

  getApps: () =>
    @components = _.find @app_bootstrap.bootstrap, (item) ->return (item.fileName == 'components')
    @apps = _.filter @components.children, (item) ->return item.type == 'folder'

  getApis: () =>
    @apiModules = @app_bootstrap.modules.api
    @apiFolders = {}
    _.map @apiModules, (currentModules, moduleName) =>
      _.map currentModules, (moduleItem) =>
        folder = moduleItem.filePath.replace moduleItem.fileName, ''
        if @apiFolders[folder] then @apiFolders[folder].push moduleItem else @apiFolders[folder] = [ moduleItem ]

  getConfigs: () ->
    configModules = @app_bootstrap.modules.configs
    @configFolders = {}
    _.map configModules, (currentModules, moduleName) =>
      _.map currentModules, (moduleItem) =>
        folder = moduleItem.filePath.replace moduleItem.fileName, ''
        if @configFolders[folder] then @configFolders[folder].push moduleItem else @configFolders[folder] = [ moduleItem ]

name = 'builderDashboard'

component = angular.module name, [
  'angular-meteor'
  'ui.router'
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: BuilderDashboard
  }
  .name
exports.BuilderDashboard = component
