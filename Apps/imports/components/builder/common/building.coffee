import templateUrl from './building.ng.jade'

class building

name = 'building'

component = angular.module name, [
  'angular-meteor'
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: building
  }
  .name

exports.Building = component
