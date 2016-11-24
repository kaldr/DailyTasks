{Analyzer} = require __dirname + '/analyzer.coffee'

class DaJieAnalyzer extends Analyzer
  constructor: () ->
    super 'dajie'

exports.DaJieAnalyzer = DaJieAnalyzer

dajie = new DaJieAnalyzer()
