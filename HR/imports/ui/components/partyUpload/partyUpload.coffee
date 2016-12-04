`import angular from 'angular';
import angularMeteor from 'angular-meteor';

import { Meteor } from 'meteor/meteor';

import template from './partyUpload.html';
import ngFileUpload from 'ng-file-upload';
import 'ng-img-crop/compile/minified/ng-img-crop';
import 'ng-img-crop/compile/minified/ng-img-crop.css';
import {Thumbs, upload } from '../../../api/images/index.coffee';`
import 'angular-sortable-view';

class PartyUpload
  constructor: ($scope, $reactive) ->
    'ngInject'
    $reactive this
      .attach $scope
    @uploaded = []
    @subscribe 'thumbs', () =>[
      @getReactively('files', true) || []
    ]
    @helpers {
      thumbs: () =>
        Thumbs.find {
          originalStore: 'images'
          originalId:
            $in: @getReactively('files', true) || []
        }
    }
  addImages: (files) =>
    if files.length
      @currentFile = files[0]
      reader = new FileReader
      reader.onload = @$bindToContext (e) =>
        @cropImgSrc = e.target.result
        @myCroppedImage = ''
      reader.readAsDataURL files[0]
    else
      @cropImgSrc = undefined
  save: () =>
    contextFunc = (file) =>
      @uploaded.push file
      if not @files then @files = []
      @files.push file._id
      @reset()
    errorFunc = (e) =>
      console.log "Oops, something went wrong", e
    #console.log @myCroppedImage
    upload @myCroppedImage, @currentFile.name, @$bindToContext(contextFunc), errorFunc
  reset: () =>
    @cropImgSrc = undefined
    @myCroppedImage = ''
name = 'partyUpload'

component = angular.module name, [
  angularMeteor
  ngFileUpload
  'ngImgCrop'
  'angular-sortable-view'
]
  .component name, {
    templateUrl: template
    controllerAs: name
    controller: PartyUpload
    bindings:
      files: "=?"
  }
  .name

exports.PartyUpload = component
