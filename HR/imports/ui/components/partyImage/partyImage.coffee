import angular from 'angular';
import angularMeteor from 'angular-meteor';

import template from './partyImage.html';
import { Images } from '../../../api/images/index.coffee';

class PartyImage
  constructor: ($scope, $reactive) ->
    'ngInject'
    $reactive this
      .attach $scope
    @helpers {
      mainImage: () =>
        images = @getReactively 'images', true
        if images
          Images.findOne {
            _id: images[0]
          }
    }
name = 'partyImage'
component = angular.module name, [
  angularMeteor
]
  .component name, {
    templateUrl: template
    bindings:
      images: "<"
    controllerAs: name
    controller: PartyImage
  }
  .name

exports.PartyImage = component
