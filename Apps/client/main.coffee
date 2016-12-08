require '/imports/plugins/util/basicRequire.coffee'
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
