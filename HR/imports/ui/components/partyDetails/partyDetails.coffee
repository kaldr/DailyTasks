import angular from 'angular'
import angularMeteor from 'angular-meteor'
import uiRouter from 'angular-ui-router'
import {Meteor} from 'meteor/meteor'

import templateUrl from './partyDetails.ng.jade'
import {Parties} from '../../../api/parties/index.coffee'
import {PartyUninvited} from '../partyUninvited/partyUninvited.coffee'
import {PartyMap} from '../partyMap/partyMap.coffee'

class PartyDetails
  constructor: ($stateParams, $scope, $reactive) ->
    'ngInject'
    $reactive this
      .attach $scope

    @partyId = $stateParams.partyId

    @subscribe 'parties'
    @subscribe 'users'

    @helpers {
        party: () =>Parties.findOne {_id: @partyId}
        users: () =>Meteor.users.find {}
        isLoggedIn: () =>not not Meteor.userId()
        isOwner: () =>
          return false if not @party
          return @party.owner == Meteor.userId()
    }

  canInvite: () =>
    return false if not @party
    return not @party.public && @party.owner == Meteor.userId()

  save: () =>
    Parties.update {
      _id: @party._id
    } , {
      $set:
        name: @party.name
        description: @party.description
        public: @party.public
        location: @party.location
    } , (error) =>
      if error
        console.log 'Oops, unable to update the party'
      else
        console.log 'Done!'

name = 'partyDetails'

config = ($stateProvider) ->
  'ngInject'
  $stateProvider.state name, {
    url: "/parties/:partyId"
    template: "<party-details></party-details>"
    resolve: {
      currentUser: ($q) =>
        if Meteor.userId() == null
          $q.reject('AUTH_REQUIRED')
        else
          $q.resolve()
    }
  }

component = angular.module name, [
  angularMeteor
  uiRouter
  PartyUninvited
  PartyMap
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: PartyDetails
  }
  .config config
  .name

exports.PartyDetails = component
