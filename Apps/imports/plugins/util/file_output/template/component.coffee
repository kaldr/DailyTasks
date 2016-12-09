import templateUrl from './_class_name.ng.jade'

class _class_name
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

name = '_class_name'

config = ($stateProvider) ->
  'ngInject'
  $stateProvider
    .state 'building__class_name', {
      url: '/building/_class_name'
      template: '<_class_name_no_camel></_class_name_no_camel>'
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
      controller: _class_name
      controllerAs: '_class_name'
    }
    .config config
    .run run
    .name

exports._class_name = component
