import '/imports/plugins/util/require/basicRequire.coffee'

smartRequire = (filename) ->
  if filename
    templateUrl = require './tourism.ng.jade'
  templateUrl


templateUrl = smartRequire 'a'

class Tourism

name = 'tourism'

exports.Tourism = angular.module name, [
  'angular-meteor'
]
  .component name, {
    templateUrl: templateUrl.default
    controllerAs: name
    controller: Tourism
  }
  .name
