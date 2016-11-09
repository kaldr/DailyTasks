# This is a crawler for http://www.dajie.com
{spider} = require __dirname + '/spider.coffee'
request = require 'request'

class Dajie extends spider
   constructor: () ->
     super 'dajie'
     console.log @config
   nextPageUrl: (pageIndex) ->
     @config.parameters.page = if pageIndex? then pageIndex else @config.parameters.page += 1
     @getUrl()

   getUrl: () ->
     @constructGetUrl @config.url, @config.parameters

   crawlFirstUrl: () ->
     request @config.requestOptions, (error, response, body) ->
       console.log body

   crawlNextUrl: () ->
     request @nextPageUrl(), @crawlNextUrl

   start: () ->
     @crawlFirstUrl()
     #@crawlNextUrl()

dj = new Dajie()
dj.start()
exports.Dajie = Dajie

# Titles = [
#   "PHP工程师"
#   "UI设计师"
#   "产品经理"
#   ".net工程师"
#   "前端开发工程师"
# ]
# ]
