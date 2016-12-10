import templateUrl from './appIntro.ng.jade'
import './appIntro.styl'

class BuilderAppIntro

name = 'builderAppIntro'

component = angular.module name, [
  "angular-meteor"
  'ui.router'
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: BuilderAppIntro
  }
  .name

exports.BuilderAppIntro = component
