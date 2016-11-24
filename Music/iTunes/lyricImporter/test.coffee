ID3 = require 'id3js'
_ = require 'lodash'
iTunes = require 'local-itunes'
filename = '/Volumes/Data/itunes/Apple Music/Taylor Swift/Ours/Ours.m4p'
# ID3.read filename, {
# onSuccess: (tag) ->
#   console.log tag
#   _.each tag.tags, (value, key) ->
#     console.log key
#     console.log value
# onError: (tag) ->
#   console.log tag
# }

iTunes.playerState (error, state) ->console.log state
#iTunes.currentPlaylist (error, state) ->console.log state, error
iTunes.currentTrack (error, data) ->console.log data, error
