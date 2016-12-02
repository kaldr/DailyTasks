import angular from 'angular'
import angularMeteor from 'angular-meteor'
import templateUrl from './navigation.ng.jade'

class Navigation

name = 'navigation'

component = angular.module name, [
  angularMeteor
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: Navigation
  }
  .name

exports.Navigation = component
