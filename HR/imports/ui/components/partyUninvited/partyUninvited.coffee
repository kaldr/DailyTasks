import angular from 'angular'
import angularMeteor from 'angular-meteor'

import {Meteor} from 'meteor/meteor'

import templateUrl from './partyUninvited.ng.jade'

import {UninvitedFilter} from '../../filters/uninvitedFilter.coffee'
import {DisplayNameFilter} from '../../filters/displayNameFilter.coffee'

class PartyUninvited
  constructor: ($scope) ->
    'ngInject'
    $scope.viewModel this
    @helpers {
      users: () =>Meteor.users.find()
    }

name = 'partyUninvited'

component = angular.module name, [
  angularMeteor
  UninvitedFilter
  DisplayNameFilter
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: PartyUninvited
  }
  .name

exports.PartyUninvited = component
