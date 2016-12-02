import angular from 'angular'
import angularMeteor from 'angular-meteor'

import templateUrl from './partiesSort.ng.jade'

class PartiesSort
  constructor: () ->
    @changed()

  changed: () =>
    ob = {
      sort: {}
    }
    ob.sort[@property] = parseInt @order
    @onChange ob

name = 'partiesSort'
component = angular.module name, [
  angularMeteor
]
  .component name, {
    templateUrl: templateUrl
    bindings:
      onChange: "&"
      property: "@"
      order: "@"
    controller: PartiesSort
    controllerAs: name
  }
  .name

exports.PartiesSort = component
