
request = require 'request'
fs = require 'fs'
Iconv = require 'iconv-lite'
moment = require 'moment'

class Spider

  constructor: () ->
    parameters =
      name: "a"
      area: "b"
      sex: 1
      year: 2016
      month: 12
      date: 24
      hour: 15
      minute: 44
      jingdu: 120
      jingdufen: 0
      taiyang: 0
      quanpai: 1
    @crawlAPaipan parameters

  crawlAPaipan: (parameters) =>
    requestOptions =
      encoding: null
      form: parameters
      url: "http://www.china95.net/paipan/bazi/bazi_show.asp"
    request.post requestOptions, (err, rsps, body) =>
      body = Iconv.decode(body, 'gb2312')
      fs.writeFile "./hello.html", body, 'utf8'
s = new Spider()
