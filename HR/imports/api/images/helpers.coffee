FileReader = require 'filereader'

dataURLToBlob = (dataURL) =>
  BASE64_MARKER = ';base64,';

  if dataURL.indexOf(BASE64_MARKER) == - 1
    parts = dataURL.split(',') ;
    contentType = parts[0].split(':')[1];
    raw = decodeURIComponent(parts[1]) ;
    return new Blob([raw], {type: contentType} ) ;

  parts = dataURL.split(BASE64_MARKER) ;
  contentType = parts[0].split(':')[1];
  raw = window.atob(parts[1]) ;
  rawLength = raw.length;
  uInt8Array = new Uint8Array(rawLength) ;

  uInt8Array[i] = raw.charCodeAt(i) for i in [0, rawLength]

  return new Blob([uInt8Array], {type: contentType} )

blobToArrayBuffer = (blob, callback, errorCallback) =>
  reader = new FileReader()
  reader.onload = (e) =>
    callback e.target.result
  reader.onerror = (e) =>
    errorCallback? e

  reader.readAsArrayBuffer blob


exports.dataURLToBlob = dataURLToBlob
exports.blobToArrayBuffer = blobToArrayBuffer
