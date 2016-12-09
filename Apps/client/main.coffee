require '/imports/plugins/util/smart_require/index.coffee'
{Tourism} = require '../imports/components/tourism/tourism.coffee'
{builder} = require '../imports/components/builder/main.coffee'
import 'angular-material/angular-material.min.css'
import './main.styl'

routeConfig = ($stateProvider, $locationProvider, $urlRouterProvider) ->
  'ngInject'
  $locationProvider.html5Mode true
  $urlRouterProvider.otherwise '/builder/app'
  $stateProvider
    .state "root", {
      url: "/"
      views:
        main:
          template: "<tourism></tourism>"
    }
    .state 'builder', {
      url: "/builder"
      views:
        main:
          template: "<builder></builder>"
    }

angular.module 'app', [
  'ui.router'
  angularMaterial
  'angular-meteor'
  'tourism'
  'builder'
]
  .config routeConfig


onReady = () =>
  angular.bootstrap document, [
    'app'
  ]

if Meteor.isCordova
	angular.element document
    .on 'deviceready', onReady
else
  angular.element document
    .ready onReady
