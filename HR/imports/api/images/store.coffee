import { UploadFS } from 'meteor/jalik:ufs';
import { Images, Thumbs } from './collection.coffee';
defaultStorePermissions = new UploadFS.StorePermissions {
  insert: (userId) =>if userId then return userId else Meteor.userId()
  update: (userId) =>if userId then return userId else Meteor.userId()
  remove: (userId) =>if userId then return userId else Meteor.userId()
}
ThumbsStore = new UploadFS.store.GridFS {
  collection: Thumbs
  name: "thumbs"
  permissions: defaultStorePermissions
  transformWrite: (from, to, fileId, file) ->
    gm = require 'gm'
    gm from, file.name
      .resize 32, 32
      .gravity 'Center'
      .extent 32, 32
      .quality 75
      .stream()
      .pipe to
}

ImagesStore = new UploadFS.store.GridFS {
  collection: Images
  name: "images"
  permissions: defaultStorePermissions
  filter: new UploadFS.Filter {
    contentTypes: ['image/*']
  }
  copyTo: [
    ThumbsStore
  ]
}

exports.ThumbsStore = ThumbsStore
exports.ImagesStore = ImagesStore
