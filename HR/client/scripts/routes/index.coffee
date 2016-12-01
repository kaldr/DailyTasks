import {Config} from 'angular-ecmascript/module-helpers'

import chatsTemplateUrl from '../../templates/chats.ng.jade'
import tabsTemplateUrl from '../../templates/tabs.ng.jade'

class RoutesConfig extends Config
  configure: () =>
    @$stateProvider
      .state 'tab', {
        url: '/tab'
        abstract: true
        templateUrl: tabsTemplateUrl
      }
      .state 'tab.chats', {
        url: '/chats'
        views:
          'tab-chats':
            templateUrl: chatsTemplateUrl
            controller: 'ChatsCtrl as chats'
      }
    @$urlRouterProvider.otherwise 'tab/chats'
    false

RoutesConfig.$inject = [
  '$stateProvider'
  '$urlRouterProvider'
]

exports.RoutesConfig = RoutesConfig
