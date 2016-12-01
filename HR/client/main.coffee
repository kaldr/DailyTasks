
import 'ionic-scripts'
import 'angular-meteor'
import 'angular-ui-router'
import 'angular-animate'
import 'angular-sanitize'
import Loader from 'angular-ecmascript/module-loader'
import Angular from 'angular'
import {Meteor} from 'meteor/meteor'
import {RoutesConfig} from './scripts/routes/index'
import {ChatsCtrl} from './scripts/controllers/chats.controller'


App = 'HR'

Angular.module App, [
  'angular-meteor'
  'ionic'
]
onReady = () ->
  Angular.bootstrap document, [App]


new Loader App
  .load ChatsCtrl
  .load RoutesConfig


if Meteor.isCordova
  Angular.element document
    .on 'deviceready', onReady
else
  Angular.element document
    .ready onReady
