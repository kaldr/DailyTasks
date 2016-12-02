import angular from 'angular'
import angularMeteor from 'angular-meteor'
import 'angular-simple-logger'
import 'angular-google-maps'

import templateUrl from './partiesMap.ng.jade'

class PartiesMap
  constructor: () ->
    @map =
      center:
        latitude: 45
        longitude: - 73
      zoom: 8

name = 'partiesMap'

component = angular.module name, [
  angularMeteor
  'nemLogging'
  'uiGmapgoogle-maps'
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: PartiesMap
    bindings:
      parties: "="
  }
  .name
exports.PartiesMap = component
