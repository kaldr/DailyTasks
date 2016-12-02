import angular from 'angular'
import angularMeteor from 'angular-meteor'

import { Meteor } from 'meteor/meteor'

import template from './partyCreator.html'
import { DisplayNameFilter } from '../../filters/displayNameFilter'

class PartyCreator
  constructor: ($scope) ->
    'ngInject'
    $scope.viewModel this
    this.subscribe 'users'
    @helpers {
      creator: () =>
        return '' if not @party
        owner = @party.owner
        return 'me' if Meteor.userId() !=null and owner = Meteor.userId()
        return Meteor.users.findOne(owner) ||'nobody'
    }
name = 'partyCreator'
component = angular.module name, [
  angularMeteor
  DisplayNameFilter
]
  .component name, {
    templateUrl: template
    controller: PartyCreator
    controllerAs: name
    bindings:
      party: "<"
  }
  .name

exports.PartyCreator = component
