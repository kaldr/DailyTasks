import { UploadFS } from 'meteor/jalik:ufs';
import { ImagesStore } from './store';
import { dataURLToBlob, blobToArrayBuffer } from './helpers';
import _ from 'underscore'

upload = (dataUrl, name, resolve, reject) =>
  blob = dataURLToBlob dataUrl
  blob.name = name
  file = _.pick blob, 'name','type','size'
  upload = (data) =>
    upload = new UploadFS.Uploader {
      data: data
      file: file
      store: ImagesStore
      onError: reject
      onComplete: resolve
    }
    upload.start()
  blobToArrayBuffer blob, upload, reject

exports.upload = upload
upload
