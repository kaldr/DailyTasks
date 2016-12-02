import angular from 'angular'
import {Meteor} from 'meteor/meteor'
import angularMeteor from 'angular-meteor'
import {Parties} from '../../../api/parties/index.coffee'
import templateUrl from './partyAdd.ng.jade'

class PartyAdd
  constructor: () ->
    @party = {}

  submit: () =>
    @party.owner = Meteor.userId()
    Parties.insert @party
    @reset()

  reset: () =>@party = {}

name = 'partyAdd'

PartyAddComponent = angular.module name, [
  angularMeteor
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: PartyAdd
  }
  .name

exports.PartyAdd = PartyAddComponent
