import fs from 'fs'
import path from 'path'
import _ from 'lodash'
###
  获取一个文件的相对路径
  @method relativePath
  @param {string} filename 文件路径
  @return {string} 相对文件路径
###
relativePath = (filename) ->
  strs = filename.split '/Apps/imports'
  filename.replace(strs[0] + "/Apps", '')

fileFolder = (filename) ->
  paths = filename.split '/'
  if paths.length >= 3
    [paths[paths.length - 2], paths[paths.length - 3]]
  else
    [paths[paths.length - 2], 'ROOT']

###
  获取一个目录的树形结构数组，并且执行callback
  @method dirTree
  @param {string} filename 文件名
  @param {string} folderType 类型
  @param {function} fileCallback 如果遍历到某文件是文件，执行此callback
  @param {function} folderCallback 如果遍历到某文件是文件夹，执行此callback
  @return {object} 返回树形对象
###
dirTree = (filename, folderType, fileCallback, folderCallback) ->
  name = path.basename(filename)
  moduleName = name.split(".")[0]
  fileType = _.last name.split(".")
  filepath = relativePath filename
  stats = fs.lstatSync(filename)
  folderInfo = fileFolder filename
  info =
    path: folderInfo[0]
    parent: folderInfo[1]
    fileName: name
    name: name
    moduleName: moduleName
    fileType: fileType
    filePath: filepath
    folderType: folderType
  if stats.isDirectory()
    info.type = 'folder'
    folderCallback? info
    info.children = fs.readdirSync(filename).map((child) ->
      dirTree filename + '/' + child, folderType, fileCallback, folderCallback
    )
  else
    # Assuming it's a file. In real life it could be a symlink or
    # something else!
    info.type = 'file'
    fileCallback? info
  info

export {dirTree, relativePath}
