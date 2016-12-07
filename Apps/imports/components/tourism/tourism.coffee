angular = require 'angular'
{angularMeteor} = require 'angular-meteor'
templateUrl = require './tourism.ng.jade'
class Tourism

name = 'tourism'
exports.Tourism = angular.module name, [
  angularMeteor
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: Tourism
  }
  .name
