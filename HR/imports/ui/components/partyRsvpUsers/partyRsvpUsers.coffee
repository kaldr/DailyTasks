import angular from 'angular'
import angularMeteor from 'angular-meteor'
import {Meteor} from 'meteor/meteor'

import templateUrl from './partyRsvpUsers.ng.jade'
import {DisplayNameFilter} from '../../filters/displayNameFilter.coffee'

class PartyRsvpUsers
  getUserById: (userId) =>Meteor.users.findOne userId

name = 'partyRsvpUsers'

exports.PartyRsvpUsers = angular.module name, [
  angularMeteor
  DisplayNameFilter
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: PartyRsvpUsers
    bindings:
      rsvps: "<"
      type: "@"
  }
  .name
