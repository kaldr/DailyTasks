#{Analyzer} = require __dirname + "/analyzer"

sync = require 'synchronize'
async = require 'async'
fs = require 'fs'
sync fs, 'readFile'

Q = require 'q'
# fs.readFile __dirname + '/README.md','utf8', (err, data) ->
#   console.log data
# console.log "this will be done before fs.readFile"


# sync.fiber () ->
#   console.log "==========================="
#   data = fs.readFile __dirname + '/README.md','utf8'
#   console.log data
#   console.log "done"

#a = new Analyzer()
#console.log a.analyseKeywords "瑞士高薪技术聘请", true

# a =
#   a: 1
#   b:
#     a: 1
#     b: 3
#
# congsole.log true if a.b?.c == 1

class test
  constructor: (@i) ->

  step1 : (j) =>
    @i += j + 5
    console.log 'this is step 1 ' + @i
    @i

  step2 : (j) =>
    @i += j + 2
    console.log 'this is step 2 ' + @i
    @i

  step3 : (j) =>
    @i += j + 22
    console.log 'this is step 3 ' + @i
    @i

  step4 : (j = 50) =>
    @i += j + 100
    console.log 'this is step 4 ' + @i
    @i

  run: () =>
    Q.when @step4
      .then @step2
      .then @step1
      .then @step3
      .done () =>
        console.log @i
    console.log "OK"
new test 300
game = [1, 33, 55].map (v) ->v
console.log game
