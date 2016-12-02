import angular from 'angular'
import angularMeteor from 'angular-meteor'

import templateUrl from './partyRsvpsList.ng.jade'
import {PartyRsvpUsers} from '../partyRsvpUsers/partyRsvpUsers.coffee'

class PartyRsvpsList

name = 'partyRsvpsList'

exports.PartyRsvpsList = angular.module name, [
  angularMeteor
  PartyRsvpUsers
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: PartyRsvpsList
    bindings:
      rsvps: "<"
  }
  .name
