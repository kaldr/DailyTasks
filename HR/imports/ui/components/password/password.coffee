import angular from 'angular';
import angularMeteor from 'angular-meteor';
import uiRouter from 'angular-ui-router';

import { Accounts } from 'meteor/accounts-base';

import template from './password.html';

class Register
  constructor: ($scope, $reactive, $state) ->
    'ngInject'
    @$state = $state
    $reactive this
      .attach $scope

    @credentials =
      email: ""

    @error = ""

  reset: () =>
    Accounts.forgotPassword @credentials, @$bindToContext (err) =>
      if err then @error = err else @$state.go('parties')

config = ($stateProvider) =>
  'ngInject'
  $stateProvider.state 'password', {
    url: "/password"
    template: "<password></password>"
  }

name = 'password'

component = angular.module name, [
  angularMeteor
  uiRouter
]
  .component name, {
    templateUrl: template
    controllerAs: name
    controller: Register
  }
  .config config
  .name

exports.Password = component
