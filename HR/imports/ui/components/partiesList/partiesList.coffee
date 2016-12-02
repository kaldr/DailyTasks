import angular from 'angular'
import angularMeteor from 'angular-meteor'
import uiRouter from 'angular-ui-router'
import templateUrl from './partiesList.ng.jade'
import {Parties} from '../../../api/parties/index.coffee'
import {PartyAdd} from '../partyAdd/partyAdd.coffee'
import {PartyRemove} from '../partyRemove/partyRemove.coffee'
import utilsPagination from 'angular-utils-pagination'
import { Counts } from 'meteor/tmeasday:publish-counts'
import {PartiesSort} from '../partiesSort/partiesSort.coffee'
import {PartyCreator} from '../partyCreator/partyCreator.coffee'
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

    @helpers
      parties: () =>Parties.find {} , {
        sort: @getReactively 'sort'
      }
      partiesCount: () =>Counts.get 'numberOfParties'

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
  PartyAdd
  PartiesSort
  PartyRemove
  PartyCreator
]
  .component name, {
    templateUrl: templateUrl
    controllerAs: name
    controller: PartiesList
  }
  .config config
  .name
exports.PartiesList = PartiesListComponent
