import {BuilderDashboard} from './dashboard/dashboard.coffee'
import {BuilderApp} from './app/app.coffee'
import {Building} from './common/building.coffee'
import templateUrl from './main.ng.jade'
import builderConfig from './config/config.coffee'
import './main.styl'
import _ from 'lodash'


class builder
  constructor: ($reactive, $scope, $state) ->
    'ngInject'

    @pickModulesByPath()
    #@rebuildModuleBootstrap()
    #$state.transitionTo("builder.dashboard")

  treeify: (arr) =>
    treeArray = {name: '', type: "folder", children: []}
    addnode = (obj) =>
      splitpath = _.drop _.compact(obj.filePath.split('/')), 2
      treeArray.fileName = _.compact(obj.filePath.split('/'))[1]
      treeArray.name = treeArray.fileName
      ptra = treeArray.children
      #console.log ptra
      i = 0
      while i < splitpath.length
        nodea =
          name: splitpath[i]
          fileName: splitpath[i]
          type: 'folder'

        if i == splitpath.length - 1
          nodea = _.cloneDeep obj
        if i < splitpath.length - 1
          nodea.children = []
        currentTree = _.find ptra, (item) =>return item.name == splitpath[i]
        if not currentTree
          ptra.push nodea
          currentTree = _.find ptra, (item) =>return item.name == splitpath[i]
        else
          if not currentTree.children
            currentTree.children = []
        ptra = currentTree.children
        i++
      return
    arr.map addnode
    treeArray

  pickModulesByPath: () =>
    _.map module_bootstraps.modules, (fileData, folderType) =>
      data = []
      _.map fileData, (files, fileType) =>
        files.forEach (file) =>data.push file
      module_bootstraps.bootstrap[folderType] = @treeify data
    console.log module_bootstraps


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
          template: "<building></building>"
    }
    .state 'builder.api', {
      url: "/api"
      parent: "builder"
      views:
        builder:
          template: "<building></building>"
    }

component = angular.module name, [
  'angular-meteor'
  'ui.router'
  angularMaterial
  BuilderApp
  BuilderDashboard
  Building
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: builder
  }
  .config config
  .name


exports.Builder = component
