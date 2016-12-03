import angular from 'angular';
import angularMeteor from 'angular-meteor';
import uiRouter from 'angular-ui-router';

import { Accounts } from 'meteor/accounts-base';

import template from './register.html';

class Register
  constructor: ($scope, $reactive, $state) ->
    'ngInject'
    @$state = $state
    $reactive this
      .attach $scope
    @credentials =
      email: ""
      password: ""

    @error = ""

  register: () =>

name = 'register'
config = ($stateProvider) =>
  'ngInject'
  $stateProvider.state 'register', {
    url: "/register"
    template: "<register></register>"
  }
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

exports.Register = component
