path = require 'path'
fs = require 'fs'

requrieComponent

# TODO: 先从当前目录里面找对应的组件，再从上级目录查找，再从上级目录的所有子目录查找，从而导入这个组件
# TODO: 当系统是server的时候，每次运行时，自动将所有的目录内容读出，并且理清楚文件架构
