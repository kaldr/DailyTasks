import templateUrl from './dashboard.ng.jade'

class BuilderDashboard
  constructor: ($scope, $rootScope) ->
    'ngInject'

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
