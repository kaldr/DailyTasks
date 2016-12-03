import angular from 'angular'
import angularMeteor from 'angular-meteor'
import uiRouter from 'angular-ui-router'
import templateUrl from './partiesList.ng.jade'
import {Parties} from '../../../api/parties/index.coffee'
#import {PartyAdd} from '../partyAdd/partyAdd.coffee'
import {PartyRemove} from '../partyRemove/partyRemove.coffee'
import utilsPagination from 'angular-utils-pagination'
import { Counts } from 'meteor/tmeasday:publish-counts'
import {PartiesSort} from '../partiesSort/partiesSort.coffee'
import {PartyCreator} from '../partyCreator/partyCreator.coffee'
import {PartyRsvp} from '../partyRsvp/partyRsvp.coffee'
import {PartyRsvpsList} from '../partyRsvpsList/partyRsvpsList.coffee'
import {PartyUnanswered} from '../partyUnanswered/partyUnanswered.coffee'
import {PartiesMap} from '../partiesMap/partiesMap.coffee'
import {PartyAddButton} from '../partyAddButton/partyAddButton.coffee'

class PartiesList
  constructor: ($scope, $reactive) ->
    'ngInject'
    $reactive this
      .attach $scope

    @perPage = 3
    @page = 1
    @sort =
      name: 1

    @searchText = ""

    @subscribe 'parties', () =>[
      {
        limit: parseInt @perPage
        skip: parseInt (@getReactively('page') - 1) * @perPage
        sort: @getReactively 'sort'
      } , @getReactively 'searchText'
    ]

    @subscribe 'users'

    @helpers
      parties: () =>Parties.find {} , {
        sort: @getReactively 'sort'
      }
      partiesCount: () =>Counts.get 'numberOfParties'
      isLoggedIn: () =>not not Meteor.userId()
      currentUserId: () =>Meteor.userId()

  isOwner: (party) =>@isLoggedIn && party.owner == @currentUserId

  pageChanged : (newPage) =>
    @page = newPage

  sortChanged : (sort) =>
    @sort = sort


name = "partiesList"

config = ($stateProvider) ->
  'ngInject'
  $stateProvider
    .state 'parties', {
      url: '/parties'
      template: '<parties-list></parties-list>'
    }

PartiesListComponent = angular.module name, [
  angularMeteor
  uiRouter
  utilsPagination
  #PartyAdd
  PartiesSort
  PartyRemove
  PartyCreator
  PartyRsvp
  PartiesMap
  PartyRsvpsList
  PartyAddButton
  #PartyUnanswered
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: PartiesList
  }
  .config config
  .name
exports.PartiesList = PartiesListComponent
