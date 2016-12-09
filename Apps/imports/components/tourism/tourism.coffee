templateUrl = require './tourism.ng.jade'

class Tourism

name = 'tourism'

exports.Tourism = angular.module name, [
  'angular-meteor'
  'ui.router'
]
  .component name, {
    templateUrl: templateUrl.default
    controllerAs: name
    controller: Tourism
  }
  .name
