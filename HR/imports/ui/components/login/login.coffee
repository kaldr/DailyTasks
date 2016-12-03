import angular from 'angular';
import angularMeteor from 'angular-meteor';
import uiRouter from 'angular-ui-router';

import { Meteor } from 'meteor/meteor';

import template from './login.html';

import { Register } from '../register/register';

class Login
  constructor: ($scope, $reactive, $state) ->
    'ngInject'
    @$state = $state
    $reactive this
      .attach $scope

    @credentials =
      email: ""
      password: ""

    @error = ""

  login: () =>
    Meteor.loginWithPassword @credentials.email, @credentials.password, @$bindToContext (err) =>
      if err then @error = err else @$state.go 'parties'

name = 'login'

config = ($stateProvider) =>
  'ngInject'
  $stateProvider.state 'login', {
    url: "/login"
    template: "<login></login>"
  }

component = angular.module name, [
  angularMeteor
  uiRouter
]
  .component name, {
    templateUrl: template
    controllerAs: name
    controller: Login
  }
  .config config
  .name

exports.Login = component
