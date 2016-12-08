fs = require('fs')
path = require('path')

_ = require 'lodash'
basePath = path.resolve('.').split('.meteor')[0]
importsPath = basePath + 'imports/'
componentPath = importsPath + 'components'
apiPath = importsPath + 'api'
starttime = Date.now()
relativePath = (filename) ->
  strs = filename.split '/Apps/imports'
  filename.replace(strs[0] + "/Apps", '')

relativePath componentPath
coffeeModules = {}
framework = fs.readdirSync(importsPath)

dirTree = (filename, folderType) ->
  name = path.basename(filename)
  moduleName = name.split(".")[0]
  fileType = _.last name.split(".")
  filepath = relativePath filename
  stats = fs.lstatSync(filename)

  info =
    path: filepath
    name: name
  if stats.isDirectory()
    info.type = 'folder'
    info.children = fs.readdirSync(filename).map((child) ->
      dirTree filename + '/' + child, folderType
    )
  else
    # Assuming it's a file. In real life it could be a symlink or
    # something else!
    info.type = 'file'
    if fileType == 'coffee'
      coffeeModules[folderType] = {} if not coffeeModules[folderType]
      if coffeeModules[folderType][moduleName]
        coffeeModules[folderType][moduleName].push filepath
      else
        coffeeModules[folderType][moduleName] = [ filepath ]
  info

if module.parent == undefined
  # node dirTree.js ~/foo/bar
  util = require('util')
  console.log util.inspect(dirTree(process.argv[2]), false, null)

framework.map (item) -> dirTree(importsPath + item , item)
#console.log info
console.log coffeeModules


# TODO: 先从当前目录里面找对应的组件，再从上级目录查找，再从上级目录的所有子目录查找，从而导入这个组件
# TODO: 当系统是server的时候，每次运行时，自动将所有的目录内容读出，并且理清楚文件架构
