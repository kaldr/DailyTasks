_ = require 'lodash'

class Dizhi
  constructor: (@name) ->

  dizhicanggan: (dizhi) =>
    canggan =
      '子': ['癸']
      '丑': ['己','癸','辛']
      '寅': ["甲","丙","戊"]
      '卯': ["乙"]
      '辰': ["戊",'乙','癸']
      '巳': ["丙",'庚','戊']
      '午': ['丁','己']
      '未': ['己','丁','乙']
      '申': ['庚','壬','戊']
      '酉': ['辛']
      '戌': ['戊','辛','丁']
      '亥': ['壬','甲']
    if dizhi then return canggan[dizhi] else return cangan

exports.Dizhi = Dizhi
