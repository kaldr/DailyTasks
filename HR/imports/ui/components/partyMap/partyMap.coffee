import angular from 'angular'
import angularMeteor from 'angular-meteor'
import 'angular-simple-logger'
import 'angular-google-maps'

import templateUrl from './partyMap.ng.jade'

class PartyMap
    constructor: ($scope) ->
      'ngInject'
      @map =
        center:
          latitude: 45
          longitude: - 73
        zoom: 8
        events: {
          click: (mapModel, eventName, originalEventArgs) =>
            @setLocation originalEventArgs[0].latLng.lat(), originalEventArgs[0].latLng.lng()
            $scope.$apply()
        }
      @marker =
        options:
          draggable: true
        events: {
          dragend: (marker, eventName, args) =>
            @setLocation marker.getPosition().lat(), marker.getPosition().lng()
            $scope.$apply()
        }
    setLocation: (latitude, longitude) =>
      @location =
        latitude: latitude
        longitude: longitude

name = 'partyMap'

component = angular.module name, [
  angularMeteor
  'nemLogging'
  'uiGmapgoogle-maps'
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: PartyMap
    bindings:
      location: "="
  }
  .name
exports.PartyMap = component
