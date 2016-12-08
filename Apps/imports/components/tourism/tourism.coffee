_ = require 'lodash'
sq = require '/imports/plugins/util/smart_require/index.coffee'


smartRequire = (filename) ->
  if filename
    templateUrl = require './tourism.ng.jade'
  templateUrl

templateUrl = smartRequire 'a'

sq.require_api('index')

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
