moment = require 'moment'
order =
	Timestamp: "2016-11-15 21:37:30"
order.DateInfo =
	timestamp: parseInt moment(order.Timestamp).format 'X'
	date: parseInt moment(order.Timestamp).format "YYYYMMDD"
	dayOfWeek: parseInt moment(order.Timestamp).format "E"
	weekOfYear: parseInt moment(order.Timestamp).format "w"
	year: parseInt moment(order.Timestamp).format "YYYY"
	month: parseInt moment(order.Timestamp).format "M"
	dayOfMonth: parseInt moment(order.Timestamp).format "D"
console.log order

###
  [game description]
  @method game
  @param {[type]} a [description]
  @param {[type]} b [description]
  @return {[type]} [description]
###
game = (a, b) ->
	1
