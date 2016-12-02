import angular from 'angular'
import angularMeteor from 'angular-meteor'

import _ from 'underscore'

import {Meteor} from 'meteor/meteor'

import templateUrl from './partyUnanswered.ng.jade'

import {DisplayNameFilter} from '../../filters/displayNameFilter.coffee'

class PartyUnanswered
  getUnanswered: () =>
    return if not @party or not @party.invited
    @party.invited.filter (user) =>
      not _.findWhere @party.rsvps, {user: user}
  getUserById: (userId) =>Meteor.users.findOne userId

name = 'partyUnanswered'

exports.PartyUnanswered = angular.module name, [
  angularMeteor
  DisplayNameFilter
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: PartyUnanswered
    bindings:
      party: "<"
  }
  .name
