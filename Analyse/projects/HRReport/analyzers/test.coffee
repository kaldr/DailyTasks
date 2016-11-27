#{Analyzer} = require __dirname + "/analyzer"

sync = require 'synchronize'

fs = require 'fs'
sync fs, 'readFile'


fs.readFile __dirname + '/README.md','utf8', (err, data) ->
  console.log data
console.log "this will be done before fs.readFile"


sync.fiber () ->
  console.log "==========================="
  data = fs.readFile __dirname + '/README.md','utf8'
  console.log data
  console.log "done"

#a = new Analyzer()
#console.log a.analyseKeywords "瑞士高薪技术聘请", true

a =
  a: 1
  b:
    a: 1
    b: 3

congsole.log true if a.b?.c == 1
