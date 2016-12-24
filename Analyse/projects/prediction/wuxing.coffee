_ = require 'lodash'
class Wuxing
  constructor: (@name) ->
    @configWuxingList()
    @relation = ['扶助','生','克','被克','被生']

  configWuxingList: () =>
    @element = ['木','火','土','金','水']

  configWuxingRelation: () =>
