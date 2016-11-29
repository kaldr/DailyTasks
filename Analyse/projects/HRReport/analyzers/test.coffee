#{Analyzer} = require __dirname + "/analyzer"

sync = require 'synchronize'
async = require 'async'
fs = require 'fs'
sync fs, 'readFile'
_ = require 'lodash'
Q = require 'q'

Request = require 'request'

api = "http://erptest.iflying.com/purchaseCenter/Disney/Test/"

dog = api + "dog"
cat = api + "cat"
turkey = api + "turkey"
food = api + "food"
breed = api + "breed"
fish = api + "fish"

i = 1


class Test
  constructor: (@i) ->
  deferredRequest: (url) ->

  request : (url) ->
    deferred = Q.defer() #⭐️ 很关键
    #console.log 'step ' + i++ + " the url is " + url
    Request url, (err, res, body) =>
      console.log 'finished step ' + url
      deferred.resolve JSON.parse body#⭐️ 很关键
    deferred.promise#⭐️ 很关键，要把当前的

  game : () ->
    rs = [
      turkey
      dog
      cat
      fish
    ]
    data = {}
    Q.all rs.map @request
      .then (response) =>
        console.log response
        Q.all [food, breed].map @request
    Q.all [
      @request dog
      @request cat
      @request turkey
      @request fish
        .then (res) =>
          data.fish = res
          return @request food
        .then (res) =>
          data.food = res
          return @request breed
        .then (res) =>
          data.breed = res
          return data
    ]
      .then (response) ->
        console.log response

# test = new Test()
# test.game()
#   .then () ->console.log 'Then'
#   .done () ->console.log "OK"
come = (value, key) =>
  console.log "hello "+key+", it's "+value+"元"
console.log _.map {a: 12, b: 33} , come
