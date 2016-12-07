require '../imports/plugins/util/require/basicRequire.coffee'

onReady = () =>
  angular.bootstrap document, [
    Tourism
  ]

if Meteor.isCordova
	angular.element document
    .on 'deviceready', onReady
else
  angular.element document
    .ready onReady
