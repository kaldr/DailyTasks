# This is a crawler for http://www.dajie.com
{spider} = require __dirname + '/spider.coffee'


class Dajie extends spider
   constructor: () ->
     super 'dajie'

new Dajie()

exports.Dajie = Dajie

# Titles = [
#   "PHP工程师"
#   "UI设计师"
#   "产品经理"
#   ".net工程师"
#   "前端开发工程师"
# ]

s = 'http://so.dajie.com/job/ajax/search/filter?jobsearch=0&pagereferer=blank&ajax=1&keyword=&page=1&order=0&from=user&salary=&recruitType=&city=330200&positionIndustry=&positionFunction=&degree=&quality=&experience=&_CSRFToken='
s.split '&'
  .forEach (item) ->
   console.log item.replace "=",":"
