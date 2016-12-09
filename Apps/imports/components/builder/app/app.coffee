import templateUrl from './app.ng.jade'

class BuilderApp

name = 'builderApp'

component = angular.module name, [
  'angular-meteor'
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: BuilderApp
  }
  .name

exports.BuilderApp = component
