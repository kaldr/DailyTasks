angular = require 'angular'
{Meteor} = require 'meteor/meteor'

import {Socially} from '../imports/ui/components/socially/socially.coffee'
import 'bootstrap/dist/css/bootstrap.css'

onReady = () =>
  angular.bootstrap document, [
    Socially
  ]

if Meteor.isCordova
	angular.element document
    .on 'deviceready', onReady
else
  angular.element document
    .ready onReady
