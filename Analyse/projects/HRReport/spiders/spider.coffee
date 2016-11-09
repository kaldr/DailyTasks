CSON = require 'cson'
fs = require 'fs'
request = require 'request'

#basic spider class
class spider
  constructor: (@name) ->
    @basicPath = './Analyse/projects/HRReport/'
    @globalConfig = CSON.load __dirname + '/config.cson'
    @config = @globalConfig[@name]
    @config.outputFolder = __dirname + '/../output/dajie/'
    @getCookie()
  crawl: () ->
  nextUrl: (index, current) ->

  getCookie: () ->
    request.get @config.requestOptions.url
      .on 'response', (response) =>
        @config.requestOptions.headers.Cookie = response.headers['set-cookie']

exports.spider = spider
