import angular from 'angular'
import angularMeteor from 'angular-meteor'

import {Meteor} from 'meteor/meteor'

import templateUrl from './partyRsvp.ng.jade'

class PartyRsvp
  yes: () =>@answer 'yes'
  maybe: () =>@answer 'maybe'
  no: () =>@answer 'no'
  answer: (answer) =>
    Meteor.call 'rsvp', @party._id, answer, (error) =>
      if error then console.error 'Oops, unable to rsvp!' else console.log 'RSVP done!'

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
