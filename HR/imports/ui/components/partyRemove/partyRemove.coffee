import angular from 'angular'
import angularMeteor from 'angular-meteor'
import {Parties} from '../../../api/parties/index.coffee'

import templateUrl from './partyRemove.ng.jade'

class PartyRemove
  constructor: () ->
  remove: () =>
    Parties.remove(@party._id) if @party
name = 'partyRemove'

PartyRemoveComponent = angular.module name, [
  angularMeteor
]
  .component name, {
    templateUrl: templateUrl
    bindings:
      party: "<"
    controllerAs: name
    controller: PartyRemove
  }
  .name

exports.PartyRemove = PartyRemoveComponent
