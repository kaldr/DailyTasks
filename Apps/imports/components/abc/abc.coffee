# generated by builder@0.1.0
import templateUrl from './abc.ng.jade'

class abc
  # 构造器
  constructor: ($reactive, $scope, $rootScope) ->
    'ngInject'
    $reactive(this).attach $scope

    # @subscribe '',()->

    # 实时数据方法
    @helpers {

    }

  # 方法
  onLoad: () ->
  initialize: () ->

name = 'abc'

config = ($stateProvider) ->
  'ngInject'
  $stateProvider
    .state 'building_abc', {
      url: '/building/abc'
      template: '<abc></abc>'
    }

run = () ->
  'ngInject'

# 导出component模块
component = angular.module name, [
    'angular-meteor'
    'ui.router'
  ]
    .component name, {
      templateUrl: templateUrl
      controller: abc
      controllerAs: 'abc'
    }
    .config config
    .run run
    .name

exports.abc = component
