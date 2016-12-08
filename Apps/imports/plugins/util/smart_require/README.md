# Smart Require
方便我们的require和import操作，并且在一个app内调整模块的路径之后，尽可能不需要修改引用，以减少出错。

## 目录

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Smart Require](#smart-require)
	- [目录](#目录)
	- [一、必要说明](#一必要说明)
	- [二、require_config.coffee](#二requireconfigcoffee)
		- [1. 调取某个文件夹下的配置](#1-调取某个文件夹下的配置)
		- [2. 其他用法举例](#2-其他用法举例)
	- [三、require_component.coffee](#三requirecomponentcoffee)
		- [1. 根据项目目录，从最外层向最里层遍历一个模块](#1-根据项目目录从最外层向最里层遍历一个模块)
		- [2. 离当前模块文件夹的最近文件夹里的模块](#2-离当前模块文件夹的最近文件夹里的模块)
		- [3. 指定模块文件夹所在上一级文件夹的导入](#3-指定模块文件夹所在上一级文件夹的导入)
	- [四、require_routes.coffee （in progress）](#四requireroutescoffee-in-progress)
	- [五、require_api.coffee](#五requireapicoffee)
		- [1. 举例](#1-举例)
		- [2. 注意](#2-注意)

<!-- /TOC -->

## 一、必要说明
模块名大小写敏感。

当前提供`imports`文件夹下的`api`、`components`、`routes`、`config`的require帮助函数，不提供`plugins`、`logs`、`test`的帮助函数。

## 二、require_config.coffee
`config`的下一级目录中，包含各个其子目录的文件，不要出现重名的情况。具体命名规则见`config`文件夹下面的`README.md`。

`config`在client或者server端都可以使用。


### 1. 调取某个文件夹下的配置

可以require某类配置下的某个module的配置对象，返回结果是object。

> 例如:文件目录结构为
```coffee-script
  imports:
    configs:
      database:
        "wechatUser.cson"
      memory:
        "index.coffee"#注意，configs及其子文件夹中可以有index.coffee，require_config会根据情况引入index.coffee
        "memory.cson"
        "cache.cson"
      dashboard:
        "dashboard.cson"
      ui:
        "index.coffee"
        "dashboard.cson"#实际上这个文件是无效的，因为下方有一个dashboard文件夹
        dashboard:
          "dashboard.cson"
          "dashboard.coffee"#注意，除了index.coffee之外，其他coffee文件，在config中，是不会被require_config检索和引用到的
```
在client或者server端的某个文件中，如果想要调用ui/dashboard目录下的dashboard.cson的配置
```coffee-script
  # ✅ 正确写法
  dashboardConfig=require_config 'ui','dashboard'
  # ✅ 正确写法
  dashboardConfig=require_ui_config 'dashboard'
```

### 2. 其他用法举例

```coffee-script
  # 返回 configs/dashboard/dashboard.cson 的配置
  # 虽然ui中也有dashboard.cson，但是只返回优先级最高的
  dashboardConfig=require_config 'dashboard'

  # 返回 configs/ui/dashboard/dashboard.cson 的配置
  dashboardConfig=require_ui_config 'dashboard'
  dashboardConfig=require_config 'ui','dashboard'

  # 返回 configs/ui/index.coffee 所引入的所有的配置
  ui=require_ui_config()
  ui=require_config 'ui'

  # 返回空，因为database下面没有index.coffee，并且也没有指定要导入哪个模块的配置
  db=require_database_config()
  db=require_config 'database'

  # 返回 configs/memory/index.coffee 所引入的所有的配置，不会返回memory.cson，因为有index.coffee，优先级更高
  memory=require_memory_config()
  memory=require_config "memory"

  # 返回 configs/memory/memory.cson 所引入的所有的配置
  memory=require_memory_config 'memory'
  memory=require_config "memory",'memory'
```
## 三、require_component.coffee
`component`只在client端调用，server端调用无意义。

要求每个模块最后exports导出的时候，都必须是angular的component，例如
```coffee-script
  import angular from 'angular'
  import angularMeteor from 'angular-meteor'

  class ControllerClass
    #控制器方法在这里
    someFunc : ()->

  #模块名
  moduleName='exampleModule'#注意angular的module名字要小写

  #定义component
  component=angular.module moduleName,[angularMeteor]
    .component moduleName,{
      templateUrl : '/path/to/template.ng.jade'#由于我们使用jade自动编译引擎，也也可以写'/path/to/template.html'
      controller : ControllerClass
      controllerAs : moduleName
    }
    .name

  #注意最后导出的必须是component
  #建议用exports.ModuleName的写法写
  exports.ExampleModuleName=component
```
其返回结果是一个字符串，上例中返回的是`moduleName`，在引入这个文件之后，angular会定义好这个组件。

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
imports:
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
imports:
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


重要规则（基于上个例子）

1. 如果有pie文件夹，无论pie所在的位置，如果pie下有index.coffee，将直接导入index.coffee

2. 如果pie文件夹下没有index.coffee，有pie.coffee，将导入pie.coffee

3. 如果pie文件夹下面没有以这两个命名的文件，将不会导入文件

4. 如果有两个pie文件夹，则会导入第一个pie文件夹下的pie.coffee，其他pie文件夹下的将永远不会被导入，但是会被提示

5. 如果没有以pie命名的文件夹，将直接检索第一个出现的pie.coffee的文件，即会导入diagram下的pie.coffee

6. 如果有两个basicPie文件夹，则返回第一个文件夹下的pie.coffee，其他将永远无法返回，但是会被提示



## 四、require_routes.coffee （in progress）
routes在client端使用，server端调用无意义。

正在考虑和比较两种方案的优劣：

方案一：通过单独写routes配置来控制；

方案二：在components里面直接写routes的config，在component里面加载。

## 五、require_api.coffee
api可以在client端或者server端调用。
调用方法与规则，与`require_component`一致

```coffee-script
  imports:
    api:
      account:
        bind:
          'bindlog.coffee'
          'index.coffee'
          'user.coffee'
        user:
          'user.coffee'
          'bind.coffee'
      tourism:
        order:
          'intentionOrder.coffee'
          'order.coffee'
```
### 1. 举例
```coffee-script
  # 返回 account/bind/index.coffee
  bind=require_account_api 'bind' # 或者
  bind=require_account_api 'bind','index'# 或者
  bind=require_api 'account','bind' # 或者
  bind=require_api 'acount' ,'bind','index'

  # 返回 account/bind/user.coffee
  user=require_account_api 'bind','user'

  # 返回 account/user/user.coffee
  user=require_account_api 'user'
```
### 2. 注意
api中都是与数据库操作相关的内容，最好每一项关键业务建一个文件夹，并且里面带有index.coffee，自己引入关键内容
