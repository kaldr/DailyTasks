###*
# 农历（阴历）万年历
# LunarCalendar
# vervison : v0.1.4
# Github : https://github.com/zzyss86/LunarCalendar
# HomePage : http://www.tuijs.com/
# Author : JasonZhou
# Email : zzyss86@qq.com
###

do ->

  extend = (o, c) ->
    if o and c and typeof c == 'object'
      for p of c
        o[p] = c[p]
    o

  creatLenArr = (year, month, len, start) ->
    arr = []
    start = start or 0
    if len < 1
      return arr
    k = start
    i = 0
    while i < len
      arr.push
        year: year
        month: month
        day: k
      k++
      i++
    arr

  errorCode =
    100: '输入的年份超过了可查询范围，仅支持1891至2100年'
    101: '参数输入错误，请查阅文档'
  cache = null
  #某年相同计算进行cache，以加速计算速度
  cacheUtil =
    current: ''
    setCurrent: (year) ->
      if @current != year
        @current = year
        @clear()
      return
    set: (key, value) ->
      if ! cache
        cache = {}
      cache[key] = value
      cache[key]
    get: (key) ->
      if ! cache
        cache = {}
      cache[key]
    clear: ->
      cache = null
      return

  formateDayD4 = (month, day) ->
    month = month + 1
    month = if month < 10 then '0' + month else month
    day = if day < 10 then '0' + day else day
    'd' + month + day

  minYear = 1890
  #最小年限
  maxYear = 2100
  #最大年限
  DATA =
    heavenlyStems: [
      '甲'
      '乙'
      '丙'
      '丁'
      '戊'
      '己'
      '庚'
      '辛'
      '壬'
      '癸'
    ]
    earthlyBranches: [
      '子'
      '丑'
      '寅'
      '卯'
      '辰'
      '巳'
      '午'
      '未'
      '申'
      '酉'
      '戌'
      '亥'
    ]
    zodiac: [
      '鼠'
      '牛'
      '虎'
      '兔'
      '龙'
      '蛇'
      '马'
      '羊'
      '猴'
      '鸡'
      '狗'
      '猪'
    ]
    solarTerm: [
      '小寒'
      '大寒'
      '立春'
      '雨水'
      '惊蛰'
      '春分'
      '清明'
      '谷雨'
      '立夏'
      '小满'
      '芒种'
      '夏至'
      '小暑'
      '大暑'
      '立秋'
      '处暑'
      '白露'
      '秋分'
      '寒露'
      '霜降'
      '立冬'
      '小雪'
      '大雪'
      '冬至'
    ]
    monthCn: [
      '正'
      '二'
      '三'
      '四'
      '五'
      '六'
      '七'
      '八'
      '九'
      '十'
      '十一'
      '十二'
    ]
    dateCn: [
      '初一'
      '初二'
      '初三'
      '初四'
      '初五'
      '初六'
      '初七'
      '初八'
      '初九'
      '初十'
      '十一'
      '十二'
      '十三'
      '十四'
      '十五'
      '十六'
      '十七'
      '十八'
      '十九'
      '二十'
      '廿一'
      '廿二'
      '廿三'
      '廿四'
      '廿五'
      '廿六'
      '廿七'
      '廿八'
      '廿九'
      '三十'
      '卅一'
    ]
  #中国节日放假安排，外部设置，0无特殊安排，1工作，2放假
  worktime = {}
  #默认设置2013-2014年放假安排

  ###*
  # 判断农历年闰月数
  # @param {Number} year 农历年
  # return 闰月数 （月份从1开始）
  ###

  getLunarLeapYear = (year) ->
    yearData = lunarInfo[year - minYear]
    yearData[0]

  ###*
  # 获取农历年份一年的每月的天数及一年的总天数
  # @param {Number} year 农历年
  ###

  getLunarYearDays = (year) ->
    `var i`
    yearData = lunarInfo[year - minYear]
    leapMonth = yearData[0]
    #闰月
    monthData = yearData[3].toString(2)
    monthDataArr = monthData.split('')
    #还原数据至16位,少于16位的在前面插入0（二进制存储时前面的0被忽略）
    i = 0
    while i < 16 - (monthDataArr.length)
      monthDataArr.unshift 0
      i++
    len = if leapMonth then 13 else 12
    #该年有几个月
    yearDays = 0
    monthDays = []
    i = 0
    while i < len
      if monthDataArr[i] == 0
        yearDays += 29
        monthDays.push 29
      else
        yearDays += 30
        monthDays.push 30
      i++
    {
      yearDays: yearDays
      monthDays: monthDays
    }

  ###*
  # 通过间隔天数查找农历日期
  # @param {Number} year,between 农历年，间隔天数
  ###

  getLunarDateByBetween = (year, between) ->
    lunarYearDays = getLunarYearDays(year)
    end = if between > 0 then between else lunarYearDays.yearDays - Math.abs(between)
    monthDays = lunarYearDays.monthDays
    tempDays = 0
    month = 0
    i = 0
    while i < monthDays.length
      tempDays += monthDays[i]
      if tempDays > end
        month = i
        tempDays = tempDays - (monthDays[i])
        break
      i++
    [
      year
      month
      end - tempDays + 1
    ]

  ###*
  # 根据距离正月初一的天数计算农历日期
  # @param {Number} year 公历年，月，日
  ###

  getLunarByBetween = (year, month, day) ->
    yearData = lunarInfo[year - minYear]
    zenMonth = yearData[1]
    zenDay = yearData[2]
    between = getDaysBetweenSolar(year, zenMonth - 1, zenDay, year, month, day)
    if between == 0
      #正月初一
      [
        year
        0
        1
      ]
    else
      lunarYear = if between > 0 then year else year - 1
      getLunarDateByBetween lunarYear, between

  ###*
  # 两个公历日期之间的天数
  ###

  getDaysBetweenSolar = (year, month, day, year1, month1, day1) ->
    date = new Date(year, month, day).getTime()
    date1 = new Date(year1, month1, day1).getTime()
    (date1 - date) / 86400000

  ###*
  # 计算农历日期离正月初一有多少天
  # @param {Number} year,month,day 农年，月(0-12，有闰月)，日
  ###

  getDaysBetweenZheng = (year, month, day) ->
    lunarYearDays = getLunarYearDays(year)
    monthDays = lunarYearDays.monthDays
    days = 0
    i = 0
    while i < monthDays.length
      if i < month
        days += monthDays[i]
      else
        break
      i++
    days + day - 1

  ###*
  # 某年的第n个节气为几日
  # 31556925974.7为地球公转周期，是毫秒
  # 1890年的正小寒点：01-05 16:02:31，1890年为基准点
  # @param {Number} y 公历年
  # @param {Number} n 第几个节气，从0小寒起算
  # 由于农历24节气交节时刻采用近似算法，可能存在少量误差(30分钟内)
  ###

  getTerm = (y, n) ->
    offDate = new Date(31556925974.7 * (y - 1890) + termInfo[n] * 60000 + Date.UTC(1890, 0, 5, 16, 2, 31))
    offDate.getUTCDate()

  ###*
  # 获取公历年一年的二十四节气
  # 返回key:日期，value:节气中文名
  ###

  getYearTerm = (year) ->
    res = {}
    month = 0
    i = 0
    while i < 24
      day = getTerm(year, i)
      if i % 2 == 0
        month++
      res[formateDayD4(month - 1, day) ] = DATA.solarTerm[i]
      i++
    res

  ###*
  # 获取生肖
  # @param {Number} year 干支所在年（默认以立春前的公历年作为基数）
  ###

  getYearZodiac = (year) ->
    num = year - 1890 + 25
    #参考干支纪年的计算，生肖对应地支
    DATA.zodiac[num % 12]

  ###*
  # 计算天干地支
  # @param {Number} num 60进制中的位置(把60个天干地支，当成一个60进制的数)
  ###

  cyclical = (num) ->
    DATA.heavenlyStems[num % 10] + DATA.earthlyBranches[num % 12]

  ###*
  # 获取干支纪年
  # @param {Number} year 干支所在年
  # @param {Number} offset 偏移量，默认为0，便于查询一个年跨两个干支纪年（以立春为分界线）
  ###

  getLunarYearName = (year, offset) ->
    offset = offset or 0
    #1890年1月小寒（小寒一般是1月5或6日）以前为己丑年，在60进制中排25
    cyclical year - 1890 + 25 + offset

  ###*
  # 获取干支纪月
  # @param {Number} year,month 公历年，干支所在月
  # @param {Number} offset 偏移量，默认为0，便于查询一个月跨两个干支纪月（有立春的2月）
  ###

  getLunarMonthName = (year, month, offset) ->
    offset = offset or 0
    #1890年1月小寒以前为丙子月，在60进制中排12
    cyclical (year - 1890) * 12 + month + 12 + offset

  ###*
  # 获取干支纪日
  # @param {Number} year,month,day 公历年，月，日
  ###

  getLunarDayName = (year, month, day) ->
    #当日与1890/1/1 相差天数
    #1890/1/1与 1970/1/1 相差29219日, 1890/1/1 日柱为壬午日(60进制18)
    dayCyclical = Date.UTC(year, month, day) / 86400000 + 29219 + 18
    cyclical dayCyclical

  ###*
  # 获取公历月份的天数
  # @param {Number} year 公历年
  # @param {Number} month 公历月
  ###

  getSolarMonthDays = (year, month) ->
    monthDays = [
      31
      if isLeapYear(year) then 29 else 28
      31
      30
      31
      30
      31
      31
      30
      31
      30
      31
    ]
    monthDays[month]

  ###*
  # 判断公历年是否是闰年
  # @param {Number} year 公历年
  ###

  isLeapYear = (year) ->
    year % 4 == 0 and year % 100 != 0 or year % 400 == 0

  ###
  # 统一日期输入参数（输入月份从1开始，内部月份统一从0开始）
  ###

  formateDate = (year, month, day, _minYear) ->
    argsLen = arguments.length
    now = new Date
    year = if argsLen then parseInt(year, 10) else now.getFullYear()
    month = if argsLen then parseInt(month - 1, 10) else now.getMonth()
    day = if argsLen then parseInt(day, 10) or now.getDate() else now.getDate()
    if year < (if _minYear then _minYear else minYear + 1) or year > maxYear
      return {
        error: 100
        msg: errorCode[100]
      }
    {
      year: year
      month: month
      day: day
    }

  ###*
  # 将农历转换为公历
  # @param {Number} year,month,day 农历年，月(1-13，有闰月)，日
  ###

  lunarToSolar = (_year, _month, _day) ->
    inputDate = formateDate(_year, _month, _day)
    if inputDate.error
      return inputDate
    year = inputDate.year
    month = inputDate.month
    day = inputDate.day
    between = getDaysBetweenZheng(year, month, day)
    #离正月初一的天数
    yearData = lunarInfo[year - minYear]
    zenMonth = yearData[1]
    zenDay = yearData[2]
    offDate = new Date(year, zenMonth - 1, zenDay).getTime() + between * 86400000
    offDate = new Date(offDate)
    {
      year: offDate.getFullYear()
      month: offDate.getMonth() + 1
      day: offDate.getDate()
    }

  ###*
  # 将公历转换为农历
  # @param {Number} year,month,day 公历年，月，日
  ###

  solarToLunar = (_year, _month, _day) ->
    inputDate = formateDate(_year, _month, _day, minYear)
    if inputDate.error
      return inputDate
    year = inputDate.year
    month = inputDate.month
    day = inputDate.day
    cacheUtil.setCurrent year
    #立春日期
    term2 = if cacheUtil.get('term2') then cacheUtil.get('term2') else cacheUtil.set('term2', getTerm(year, 2))
    #二十四节气
    termList = if cacheUtil.get('termList') then cacheUtil.get('termList') else cacheUtil.set('termList', getYearTerm(year))
    firstTerm = getTerm(year, month * 2)
    #某月第一个节气开始日期
    GanZhiYear = if month > 1 or month == 1 and day >= term2 then year + 1 else year
    #干支所在年份
    GanZhiMonth = if day >= firstTerm then month + 1 else month
    #干支所在月份（以节气为界）
    lunarDate = getLunarByBetween(year, month, day)
    lunarLeapMonth = getLunarLeapYear(lunarDate[0])
    lunarMonthName = ''
    if lunarLeapMonth > 0 and lunarLeapMonth == lunarDate[1]
      lunarMonthName = '闰' + DATA.monthCn[lunarDate[1] - 1] + '月'
    else if lunarLeapMonth > 0 and lunarDate[1] > lunarLeapMonth
      lunarMonthName = DATA.monthCn[lunarDate[1] - 1] + '月'
    else
      lunarMonthName = DATA.monthCn[lunarDate[1]] + '月'
    #农历节日判断
    lunarFtv = ''
    lunarMonthDays = getLunarYearDays(lunarDate[0]).monthDays
    #除夕
    if lunarDate[1] == lunarMonthDays.length - 1 and lunarDate[2] == lunarMonthDays[lunarMonthDays.length - 1]
      lunarFtv = lunarFestival['d0100']
    else if lunarLeapMonth > 0 and lunarDate[1] > lunarLeapMonth
      lunarFtv = lunarFestival[formateDayD4(lunarDate[1] - 1, lunarDate[2]) ]
    else
      lunarFtv = lunarFestival[formateDayD4(lunarDate[1], lunarDate[2]) ]
    res =
      zodiac: getYearZodiac(GanZhiYear)
      GanZhiYear: getLunarYearName(GanZhiYear)
      GanZhiMonth: getLunarMonthName(year, GanZhiMonth)
      GanZhiDay: getLunarDayName(year, month, day)
      worktime: if worktime['y' + year] and worktime['y' + year][formateDayD4(month, day)] then worktime['y' + year][formateDayD4(month, day) ] else 0
      term: termList[formateDayD4(month, day) ]
      lunarYear: lunarDate[0]
      lunarMonth: lunarDate[1] + 1
      lunarDay: lunarDate[2]
      lunarMonthName: lunarMonthName
      lunarDayName: DATA.dateCn[lunarDate[2] - 1]
      lunarLeapMonth: lunarLeapMonth
      solarFestival: solarFestival[formateDayD4(month, day) ]
      lunarFestival: lunarFtv
    res

  ###*
  # 获取指定公历月份的农历数据
  # return res{Object}
  # @param {Number} year,month 公历年，月
  # @param {Boolean} fill 是否用上下月数据补齐首尾空缺，首例数据从周日开始
  ###

  calendar = (_year, _month, fill) ->
    inputDate = formateDate(_year, _month)
    if inputDate.error
      return inputDate
    year = inputDate.year
    month = inputDate.month
    calendarData = solarCalendar(year, month + 1, fill)
    i = 0
    while i < calendarData.monthData.length
      cData = calendarData.monthData[i]
      lunarData = solarToLunar(cData.year, cData.month, cData.day)
      extend calendarData.monthData[i], lunarData
      i++
    calendarData

  ###*
  # 公历某月日历
  # return res{Object}
  # @param {Number} year,month 公历年，月
  # @param {Boolean} fill 是否用上下月数据补齐首尾空缺，首例数据从周日开始 (7*6阵列)
  ###

  solarCalendar = (_year, _month, fill) ->
    inputDate = formateDate(_year, _month)
    if inputDate.error
      return inputDate
    year = inputDate.year
    month = inputDate.month
    firstDate = new Date(year, month, 1)
    preMonthDays = undefined
    preMonthData = undefined
    nextMonthData = undefined
    res =
      firstDay: firstDate.getDay()
      monthDays: getSolarMonthDays(year, month)
      monthData: []
    res.monthData = creatLenArr(year, month + 1, res.monthDays, 1)
    if fill
      if res.firstDay > 0
        #前补
        preYear = if month - 1 < 0 then year - 1 else year
        preMonth = if month - 1 < 0 then 11 else month - 1
        preMonthDays = getSolarMonthDays(preYear, preMonth)
        preMonthData = creatLenArr(preYear, preMonth + 1, res.firstDay, preMonthDays - (res.firstDay) + 1)
        res.monthData = preMonthData.concat(res.monthData)
      if 7 * 6 - (res.monthData.length) != 0
        #后补
        nextYear = if month + 1 > 11 then year + 1 else year
        nextMonth = if month + 1 > 11 then 0 else month + 1
        fillLen = 7 * 6 - (res.monthData.length)
        nextMonthData = creatLenArr(nextYear, nextMonth + 1, fillLen, 1)
        res.monthData = res.monthData.concat(nextMonthData)
    res

  ###*
  # 设置放假安排【对外暴露接口】
  # @param {Object} workData
  ###

  setWorktime = (workData) ->
    extend worktime, workData
    return

  worktime.y2013 =
    'd0101': 2
    'd0102': 2
    'd0103': 2
    'd0105': 1
    'd0106': 1
    'd0209': 2
    'd0210': 2
    'd0211': 2
    'd0212': 2
    'd0213': 2
    'd0214': 2
    'd0215': 2
    'd0216': 1
    'd0217': 1
    'd0404': 2
    'd0405': 2
    'd0406': 2
    'd0407': 1
    'd0427': 1
    'd0428': 1
    'd0429': 2
    'd0430': 2
    'd0501': 2
    'd0608': 1
    'd0609': 1
    'd0610': 2
    'd0611': 2
    'd0612': 2
    'd0919': 2
    'd0920': 2
    'd0921': 2
    'd0922': 1
    'd0929': 1
    'd1001': 2
    'd1002': 2
    'd1003': 2
    'd1004': 2
    'd1005': 2
    'd1006': 2
    'd1007': 2
    'd1012': 1
  worktime.y2014 =
    'd0101': 2
    'd0126': 1
    'd0131': 2
    'd0201': 2
    'd0202': 2
    'd0203': 2
    'd0204': 2
    'd0205': 2
    'd0206': 2
    'd0208': 1
    'd0405': 2
    'd0407': 2
    'd0501': 2
    'd0502': 2
    'd0503': 2
    'd0504': 1
    'd0602': 2
    'd0908': 2
    'd0928': 1
    'd1001': 2
    'd1002': 2
    'd1003': 2
    'd1004': 2
    'd1005': 2
    'd1006': 2
    'd1007': 2
    'd1011': 1
  #公历节日
  solarFestival =
    'd0101': '元旦节'
    'd0202': '世界湿地日'
    'd0210': '国际气象节'
    'd0214': '情人节'
    'd0301': '国际海豹日'
    'd0303': '全国爱耳日'
    'd0305': '学雷锋纪念日'
    'd0308': '妇女节'
    'd0312': '植树节 孙中山逝世纪念日'
    'd0314': '国际警察日'
    'd0315': '消费者权益日'
    'd0317': '中国国医节 国际航海日'
    'd0321': '世界森林日 消除种族歧视国际日 世界儿歌日'
    'd0322': '世界水日'
    'd0323': '世界气象日'
    'd0324': '世界防治结核病日'
    'd0325': '全国中小学生安全教育日'
    'd0330': '巴勒斯坦国土日'
    'd0401': '愚人节 全国爱国卫生运动月(四月) 税收宣传月(四月)'
    'd0407': '世界卫生日'
    'd0422': '世界地球日'
    'd0423': '世界图书和版权日'
    'd0424': '亚非新闻工作者日'
    'd0501': '劳动节'
    'd0504': '青年节'
    'd0505': '碘缺乏病防治日'
    'd0508': '世界红十字日'
    'd0512': '国际护士节'
    'd0515': '国际家庭日'
    'd0517': '世界电信日'
    'd0518': '国际博物馆日'
    'd0520': '全国学生营养日'
    'd0522': '国际生物多样性日'
    'd0523': '国际牛奶日'
    'd0531': '世界无烟日'
    'd0601': '国际儿童节'
    'd0605': '世界环境日'
    'd0606': '全国爱眼日'
    'd0617': '防治荒漠化和干旱日'
    'd0623': '国际奥林匹克日'
    'd0625': '全国土地日'
    'd0626': '国际禁毒日'
    'd0701': '香港回归纪念日 中共诞辰 世界建筑日'
    'd0702': '国际体育记者日'
    'd0707': '抗日战争纪念日'
    'd0711': '世界人口日'
    'd0730': '非洲妇女日'
    'd0801': '建军节'
    'd0808': '中国男子节(爸爸节)'
    'd0815': '抗日战争胜利纪念'
    'd0908': '国际扫盲日 国际新闻工作者日'
    'd0909': '毛泽东逝世纪念'
    'd0910': '中国教师节'
    'd0914': '世界清洁地球日'
    'd0916': '国际臭氧层保护日'
    'd0918': '九一八事变纪念日'
    'd0920': '国际爱牙日'
    'd0927': '世界旅游日'
    'd0928': '孔子诞辰'
    'd1001': '国庆节 世界音乐日 国际老人节'
    'd1002': '国际和平与民主自由斗争日'
    'd1004': '世界动物日'
    'd1006': '老人节'
    'd1008': '全国高血压日 世界视觉日'
    'd1009': '世界邮政日 万国邮联日'
    'd1010': '辛亥革命纪念日 世界精神卫生日'
    'd1013': '世界保健日 国际教师节'
    'd1014': '世界标准日'
    'd1015': '国际盲人节(白手杖节)'
    'd1016': '世界粮食日'
    'd1017': '世界消除贫困日'
    'd1022': '世界传统医药日'
    'd1024': '联合国日 世界发展信息日'
    'd1031': '世界勤俭日'
    'd1107': '十月社会主义革命纪念日'
    'd1108': '中国记者日'
    'd1109': '全国消防安全宣传教育日'
    'd1110': '世界青年节'
    'd1111': '国际科学与和平周(本日所属的一周)'
    'd1112': '孙中山诞辰纪念日'
    'd1114': '世界糖尿病日'
    'd1117': '国际大学生节 世界学生节'
    'd1121': '世界问候日 世界电视日'
    'd1129': '国际声援巴勒斯坦人民国际日'
    'd1201': '世界艾滋病日'
    'd1203': '世界残疾人日'
    'd1205': '国际经济和社会发展志愿人员日'
    'd1208': '国际儿童电视日'
    'd1209': '世界足球日'
    'd1210': '世界人权日'
    'd1212': '西安事变纪念日'
    'd1213': '南京大屠杀(1937年)纪念日！紧记血泪史！'
    'd1220': '澳门回归纪念'
    'd1221': '国际篮球日'
    'd1224': '平安夜'
    'd1225': '圣诞节'
    'd1226': '毛泽东诞辰纪念'
  #农历节日
  lunarFestival =
    'd0101': '春节'
    'd0115': '元宵节'
    'd0202': '龙抬头节'
    'd0323': '妈祖生辰'
    'd0505': '端午节'
    'd0707': '七夕情人节'
    'd0715': '中元节'
    'd0815': '中秋节'
    'd0909': '重阳节'
    'd1015': '下元节'
    'd1208': '腊八节'
    'd1223': '小年'
    'd0100': '除夕'

  ###*
  # 1890 - 2100 年的农历数据
  # 数据格式：[0,2,9,21936]
  # [闰月所在月，0为没有闰月; *正月初一对应公历月; *正月初一对应公历日; *农历每月的天数的数组（需转换为二进制,得到每月大小，0=小月(29日),1=大月(30日)）;]
  ###

  lunarInfo = [
    [
      2
      1
      21
      22184
    ]
    [
      0
      2
      9
      21936
    ]
    [
      6
      1
      30
      9656
    ]
    [
      0
      2
      17
      9584
    ]
    [
      0
      2
      6
      21168
    ]
    [
      5
      1
      26
      43344
    ]
    [
      0
      2
      13
      59728
    ]
    [
      0
      2
      2
      27296
    ]
    [
      3
      1
      22
      44368
    ]
    [
      0
      2
      10
      43856
    ]
    [
      8
      1
      30
      19304
    ]
    [
      0
      2
      19
      19168
    ]
    [
      0
      2
      8
      42352
    ]
    [
      5
      1
      29
      21096
    ]
    [
      0
      2
      16
      53856
    ]
    [
      0
      2
      4
      55632
    ]
    [
      4
      1
      25
      27304
    ]
    [
      0
      2
      13
      22176
    ]
    [
      0
      2
      2
      39632
    ]
    [
      2
      1
      22
      19176
    ]
    [
      0
      2
      10
      19168
    ]
    [
      6
      1
      30
      42200
    ]
    [
      0
      2
      18
      42192
    ]
    [
      0
      2
      6
      53840
    ]
    [
      5
      1
      26
      54568
    ]
    [
      0
      2
      14
      46400
    ]
    [
      0
      2
      3
      54944
    ]
    [
      2
      1
      23
      38608
    ]
    [
      0
      2
      11
      38320
    ]
    [
      7
      2
      1
      18872
    ]
    [
      0
      2
      20
      18800
    ]
    [
      0
      2
      8
      42160
    ]
    [
      5
      1
      28
      45656
    ]
    [
      0
      2
      16
      27216
    ]
    [
      0
      2
      5
      27968
    ]
    [
      4
      1
      24
      44456
    ]
    [
      0
      2
      13
      11104
    ]
    [
      0
      2
      2
      38256
    ]
    [
      2
      1
      23
      18808
    ]
    [
      0
      2
      10
      18800
    ]
    [
      6
      1
      30
      25776
    ]
    [
      0
      2
      17
      54432
    ]
    [
      0
      2
      6
      59984
    ]
    [
      5
      1
      26
      27976
    ]
    [
      0
      2
      14
      23248
    ]
    [
      0
      2
      4
      11104
    ]
    [
      3
      1
      24
      37744
    ]
    [
      0
      2
      11
      37600
    ]
    [
      7
      1
      31
      51560
    ]
    [
      0
      2
      19
      51536
    ]
    [
      0
      2
      8
      54432
    ]
    [
      6
      1
      27
      55888
    ]
    [
      0
      2
      15
      46416
    ]
    [
      0
      2
      5
      22176
    ]
    [
      4
      1
      25
      43736
    ]
    [
      0
      2
      13
      9680
    ]
    [
      0
      2
      2
      37584
    ]
    [
      2
      1
      22
      51544
    ]
    [
      0
      2
      10
      43344
    ]
    [
      7
      1
      29
      46248
    ]
    [
      0
      2
      17
      27808
    ]
    [
      0
      2
      6
      46416
    ]
    [
      5
      1
      27
      21928
    ]
    [
      0
      2
      14
      19872
    ]
    [
      0
      2
      3
      42416
    ]
    [
      3
      1
      24
      21176
    ]
    [
      0
      2
      12
      21168
    ]
    [
      8
      1
      31
      43344
    ]
    [
      0
      2
      18
      59728
    ]
    [
      0
      2
      8
      27296
    ]
    [
      6
      1
      28
      44368
    ]
    [
      0
      2
      15
      43856
    ]
    [
      0
      2
      5
      19296
    ]
    [
      4
      1
      25
      42352
    ]
    [
      0
      2
      13
      42352
    ]
    [
      0
      2
      2
      21088
    ]
    [
      3
      1
      21
      59696
    ]
    [
      0
      2
      9
      55632
    ]
    [
      7
      1
      30
      23208
    ]
    [
      0
      2
      17
      22176
    ]
    [
      0
      2
      6
      38608
    ]
    [
      5
      1
      27
      19176
    ]
    [
      0
      2
      15
      19152
    ]
    [
      0
      2
      3
      42192
    ]
    [
      4
      1
      23
      53864
    ]
    [
      0
      2
      11
      53840
    ]
    [
      8
      1
      31
      54568
    ]
    [
      0
      2
      18
      46400
    ]
    [
      0
      2
      7
      46752
    ]
    [
      6
      1
      28
      38608
    ]
    [
      0
      2
      16
      38320
    ]
    [
      0
      2
      5
      18864
    ]
    [
      4
      1
      25
      42168
    ]
    [
      0
      2
      13
      42160
    ]
    [
      10
      2
      2
      45656
    ]
    [
      0
      2
      20
      27216
    ]
    [
      0
      2
      9
      27968
    ]
    [
      6
      1
      29
      44448
    ]
    [
      0
      2
      17
      43872
    ]
    [
      0
      2
      6
      38256
    ]
    [
      5
      1
      27
      18808
    ]
    [
      0
      2
      15
      18800
    ]
    [
      0
      2
      4
      25776
    ]
    [
      3
      1
      23
      27216
    ]
    [
      0
      2
      10
      59984
    ]
    [
      8
      1
      31
      27432
    ]
    [
      0
      2
      19
      23232
    ]
    [
      0
      2
      7
      43872
    ]
    [
      5
      1
      28
      37736
    ]
    [
      0
      2
      16
      37600
    ]
    [
      0
      2
      5
      51552
    ]
    [
      4
      1
      24
      54440
    ]
    [
      0
      2
      12
      54432
    ]
    [
      0
      2
      1
      55888
    ]
    [
      2
      1
      22
      23208
    ]
    [
      0
      2
      9
      22176
    ]
    [
      7
      1
      29
      43736
    ]
    [
      0
      2
      18
      9680
    ]
    [
      0
      2
      7
      37584
    ]
    [
      5
      1
      26
      51544
    ]
    [
      0
      2
      14
      43344
    ]
    [
      0
      2
      3
      46240
    ]
    [
      4
      1
      23
      46416
    ]
    [
      0
      2
      10
      44368
    ]
    [
      9
      1
      31
      21928
    ]
    [
      0
      2
      19
      19360
    ]
    [
      0
      2
      8
      42416
    ]
    [
      6
      1
      28
      21176
    ]
    [
      0
      2
      16
      21168
    ]
    [
      0
      2
      5
      43312
    ]
    [
      4
      1
      25
      29864
    ]
    [
      0
      2
      12
      27296
    ]
    [
      0
      2
      1
      44368
    ]
    [
      2
      1
      22
      19880
    ]
    [
      0
      2
      10
      19296
    ]
    [
      6
      1
      29
      42352
    ]
    [
      0
      2
      17
      42208
    ]
    [
      0
      2
      6
      53856
    ]
    [
      5
      1
      26
      59696
    ]
    [
      0
      2
      13
      54576
    ]
    [
      0
      2
      3
      23200
    ]
    [
      3
      1
      23
      27472
    ]
    [
      0
      2
      11
      38608
    ]
    [
      11
      1
      31
      19176
    ]
    [
      0
      2
      19
      19152
    ]
    [
      0
      2
      8
      42192
    ]
    [
      6
      1
      28
      53848
    ]
    [
      0
      2
      15
      53840
    ]
    [
      0
      2
      4
      54560
    ]
    [
      5
      1
      24
      55968
    ]
    [
      0
      2
      12
      46496
    ]
    [
      0
      2
      1
      22224
    ]
    [
      2
      1
      22
      19160
    ]
    [
      0
      2
      10
      18864
    ]
    [
      7
      1
      30
      42168
    ]
    [
      0
      2
      17
      42160
    ]
    [
      0
      2
      6
      43600
    ]
    [
      5
      1
      26
      46376
    ]
    [
      0
      2
      14
      27936
    ]
    [
      0
      2
      2
      44448
    ]
    [
      3
      1
      23
      21936
    ]
    [
      0
      2
      11
      37744
    ]
    [
      8
      2
      1
      18808
    ]
    [
      0
      2
      19
      18800
    ]
    [
      0
      2
      8
      25776
    ]
    [
      6
      1
      28
      27216
    ]
    [
      0
      2
      15
      59984
    ]
    [
      0
      2
      4
      27424
    ]
    [
      4
      1
      24
      43872
    ]
    [
      0
      2
      12
      43744
    ]
    [
      0
      2
      2
      37600
    ]
    [
      3
      1
      21
      51568
    ]
    [
      0
      2
      9
      51552
    ]
    [
      7
      1
      29
      54440
    ]
    [
      0
      2
      17
      54432
    ]
    [
      0
      2
      5
      55888
    ]
    [
      5
      1
      26
      23208
    ]
    [
      0
      2
      14
      22176
    ]
    [
      0
      2
      3
      42704
    ]
    [
      4
      1
      23
      21224
    ]
    [
      0
      2
      11
      21200
    ]
    [
      8
      1
      31
      43352
    ]
    [
      0
      2
      19
      43344
    ]
    [
      0
      2
      7
      46240
    ]
    [
      6
      1
      27
      46416
    ]
    [
      0
      2
      15
      44368
    ]
    [
      0
      2
      5
      21920
    ]
    [
      4
      1
      24
      42448
    ]
    [
      0
      2
      12
      42416
    ]
    [
      0
      2
      2
      21168
    ]
    [
      3
      1
      22
      43320
    ]
    [
      0
      2
      9
      26928
    ]
    [
      7
      1
      29
      29336
    ]
    [
      0
      2
      17
      27296
    ]
    [
      0
      2
      6
      44368
    ]
    [
      5
      1
      26
      19880
    ]
    [
      0
      2
      14
      19296
    ]
    [
      0
      2
      3
      42352
    ]
    [
      4
      1
      24
      21104
    ]
    [
      0
      2
      10
      53856
    ]
    [
      8
      1
      30
      59696
    ]
    [
      0
      2
      18
      54560
    ]
    [
      0
      2
      7
      55968
    ]
    [
      6
      1
      27
      27472
    ]
    [
      0
      2
      15
      22224
    ]
    [
      0
      2
      5
      19168
    ]
    [
      4
      1
      25
      42216
    ]
    [
      0
      2
      12
      42192
    ]
    [
      0
      2
      1
      53584
    ]
    [
      2
      1
      21
      55592
    ]
    [
      0
      2
      9
      54560
    ]
  ]

  ###*
  # 二十四节气数据，节气点时间（单位是分钟）
  # 从0小寒起算
  ###

  termInfo = [
    0
    21208
    42467
    63836
    85337
    107014
    128867
    150921
    173149
    195551
    218072
    240693
    263343
    285989
    308563
    331033
    353350
    375494
    397447
    419210
    440795
    462224
    483532
    504758
  ]
  LunarCalendar =
    solarToLunar: solarToLunar
    lunarToSolar: lunarToSolar
    calendar: calendar
    solarCalendar: solarCalendar
    setWorktime: setWorktime
    getSolarMonthDays: getSolarMonthDays
  if typeof define == 'function'
    define ->
      LunarCalendar
  else if typeof exports == 'object'
    module.exports = LunarCalendar
  else
    window.LunarCalendar = LunarCalendar
  return
