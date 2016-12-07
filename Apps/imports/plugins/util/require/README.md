# require
方便我们的require和import操作，并且在一个app内调整模块的路径之后，尽可能不需要修改引用，以减少出错。
## 必要说明
模块名大小写敏感。

## require_component.coffee

### 1. 根据项目目录，从最外层向最里层遍历一个模块

```coffee-script
  # 从components的某个app中获取最外层的一个模块
  # 两个参数都为必须参数
  # app的名字中不能含有‘/’
  component = require_component 'app','name'
  # 也可以写成
  component = require_appname_component 'name'
```
> 例:文件目录结构如下
```coffee-script
components:
    common:
      diagram:
        'diagram.coffee'
    ...
    tourism:
      dashboard:
        'dashborad.coffee'
```
如果要在dashboard.coffee中，导入diagram.coffee模块，可以在dashboard.coffee中如下写：
```coffee-script
# 参数中，Diagram大小写敏感
DiagramComponent=require_component 'common','Diagram'
#或
DiagramComponent=require_common_component 'Diagram'
```


### 2. 离当前模块文件夹的最近文件夹里的模块
```coffee-script
  # 导入一个离当前模块最近模块，__dirname是必须输入的参数
  # 在任何模块中，都写__dirname
  component = require_component __dirname,'name'
```
这种模式**不支持**require_appname_component的模式。
遍历方式会先遍历当前文件夹，之后遍历同级别文件夹，再往上递推。

### 3. 指定模块文件夹所在上一级文件夹的导入
> 例:文件目录结构如下
```coffee-script
components:
    common:
      diagram:
        'pie.coffee'
        'diagram.coffee'
      pie:
        'pie.coffee'
        donut:
          'pie.coffee'
        basicPie:
          'pie.coffee'
    ···
    tourism:
      dashboard:
        'dashborad.coffee'
```
如果在dashboard.coffee中，想要获取basicPie下的pie.coffee：
```coffee-script
  # ✅ 正确做法
  DiagramComponent=require_component 'common','basicPie','pie'
  # ✅ 正确做法
  DiagramComponent=require_common_component 'basicPie','pie'
  # ❎ 错误做法:按照此时的文件目录，会返回pie文件夹下的pie.coffee
  DiagramComponent=require_component 'common','pie'
```
重要规则
1. 如果有pie文件夹，无论pie所在的位置，如果pie下有index.coffee，将直接导入index.coffee
2. 如果pie文件夹下没有index.coffee，有pie.coffee，将导入pie.coffee
3. 如果pie文件夹下面没有以这两个命名的文件，将不会导入文件
4. 如果有两个pie文件夹，则会导入第一个pie文件夹下的pie.coffee，其他pie文件夹下的将永远不会被导入，但是会被提示
5. 如果没有以pie命名的文件夹，将直接检索第一个出现的pie.coffee的文件，即会导入diagram下的pie.coffee
6. 如果有两个basicPie文件夹，则返回第一个文件夹下的pie.coffee，其他将永远无法返回，但是会被提示
