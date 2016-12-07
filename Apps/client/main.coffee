require '/imports/plugins/util/require/basicRequire.coffee'
{Tourism} = require '../imports/components/tourism/tourism.coffee'



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
