import angular from 'angular'
import angularMeteor from 'angular-meteor'
import _ from 'underscore'
import {Meteor} from 'meteor/meteor'

import templateUrl from './partyRsvp.ng.jade'

class PartyRsvp
  yes: () =>@answer 'yes'
  maybe: () =>@answer 'maybe'
  no: () =>@answer 'no'
  isYes: () =>@isAnswer 'yes'
  isNo: () =>@isAnswer 'no'
  isMaybe: () =>@isAnswer 'maybe'
  answer: (answer) =>
    Meteor.call 'rsvp', @party._id, answer, (error) =>
      if error then console.error 'Oops, unable to rsvp!' else console.log 'RSVP done!'
  isAnswer: (answer) =>
    if @party
      not not _.findWhere @party.rsvps, {
        user: Meteor.userId()
        rsvp: answer
      }

name = 'partyRsvp'

component = angular.module name, [
  angularMeteor
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    bindings:
      party: "<"
    controller: PartyRsvp
  }
  .name

exports.PartyRsvp = component
