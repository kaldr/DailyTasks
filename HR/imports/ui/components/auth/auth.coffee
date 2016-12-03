import angular from 'angular';
import angularMeteor from 'angular-meteor';

import { Meteor } from 'meteor/meteor';
import { Accounts } from 'meteor/accounts-base';

import template from './auth.html';
import { DisplayNameFilter } from '../../filters/displayNameFilter';
import {Login } from '../login/login.coffee';
import {Register } from '../register/register.coffee';
import {Password } from '../password/password.coffee';

name = 'auth'
class Auth
  constructor: ($scope, $reactive) ->
    'ngInject'
    $reactive this
      .attach $scope

    @helpers {
      isLoggedIn: () =>not not Meteor.userId()
      currentUser: () =>Meteor.user()
    }

  logout: () ->Accounts.logout()

component = angular.module name, [
  angularMeteor
  DisplayNameFilter
  Login
  Register
  Password
]
  .component name, {
    templateUrl: template
    controllerAs: name
    controller: Auth
  }
  .name

exports.Auth = component
