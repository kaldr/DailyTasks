(function() {
  var ID3, _, filename, iTunes;

  ID3 = require('id3js');

  _ = require('lodash');

  iTunes = require('local-itunes');

  filename = '/Volumes/Data/itunes/Apple Music/Taylor Swift/Ours/Ours.m4p';

  iTunes.playerState(function(error, state) {
    return console.log(state);
  });

  iTunes.currentTrack(function(error, data) {
    return console.log(data, error);
  });

}).call(this);
