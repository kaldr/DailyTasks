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


### 2. 离当前模块最近的模块
```coffee-script
  # 导入一个离当前模块最近模块，__dirname是必须输入的参数
  # 在任何模块中，都写__dirname
  component = require_component  __dirname,'name'
```
这种模式**不支持**require_appname_component的模式


### 3. 指定模块文件夹所在上一级文件夹的导入
> 例:文件目录结构如下
```coffee-script
components:
    common:
      diagram:
        'diagram.coffee'
      pie:
        'pie.coffee'
        donut:
          'pie.coffee'
        basicPie:
          'pie.coffee'

    tourism:
      dashboard:
        'dashborad.coffee'
```
