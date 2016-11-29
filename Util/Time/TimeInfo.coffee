moment = require 'moment'

class TimeInfo
  constructor: (time) ->
    return @getTimeInfo time

  getTimeInfo: (time) ->
    return TimeInfo =
      timestamp: parseInt moment(time).format 'X'
      date: parseInt moment(time).format "YYYYMMDDHHmmss"
      dayOfWeek: parseInt moment(time).format "E"
      weekOfYear: parseInt moment(time).format "w"
      year: parseInt moment(time).format "YYYY"
      month: parseInt moment(time).format "M"
      dayOfMonth: parseInt moment(time).format "D"

exports.TimeInfo = TimeInfo
