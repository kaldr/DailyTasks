# This is a crawler for http://www.dajie.com
{spider} = require __dirname + '/spider.coffee'
request = require 'request'
fs = require 'fs'

class Dajie extends spider
   constructor: () ->
     super 'dajie'

   # 下一个页面的url地址
   nextPageUrl: (pageIndex) ->
     @config.parameters.page = @config.parameters.page += 1
     @getUrl()

   # 根据参数，获取get的url的地址
   getUrl: () ->
     @constructGetUrl @config.url, @config.parameters

   setNewCookie: (cookie) ->
     @config.requestOptions.headers.Cookie = cookie
   # 保存抓取的数据
   saveCrawledData: (data) ->
      fs.writeFile @config.outputFolder + "/"+@taskID+"_" + @config.parameters.page+".json", data
      obData = JSON.parse data
      obData.taskID = @taskID
      obData.pageID = @config.parameters.page
      @db.collection 'DaJieCrawled'
        .insert obData, {} , () ->console.log "Inserted data to mongodb."

   # 爬取第一个url
   crawlFirstUrl: () =>
     console.log "Crawling the first page for basic data..."
     request @config.requestOptions, (error, response, body) =>
       @setNewCookie response.headers['set-cookie']
       bodyObj = JSON.parse body
       @totalPage = bodyObj.data.totalPage
       console.log "Total Page: " + @totalPage
       @crawlNextUrl error, response, body

   # 循环爬取url
   crawlNextUrl: (error, response, body) =>
     console.log "Finish crawling page "+@config.parameters.page+", saving to file system and mongodb and starting the next page..."
     @saveCrawledData body
     @config.requestOptions.headers.Cookie = @cookie
     @config.requestOptions.url = @nextPageUrl()
     getNextRequest = () =>
         request @config.requestOptions, @crawlNextUrl
     if @config.parameters.page <= @totalPage
       setTimeout(getNextRequest, 1000)


   start: () ->
     @crawlFirstUrl()

dj = new Dajie()
exports.Dajie = Dajie

# Titles = [
#   "PHP工程师"
#   "UI设计师"
#   "产品经理"
#   ".net工程师"
#   "前端开发工程师"
# ]
# ]
