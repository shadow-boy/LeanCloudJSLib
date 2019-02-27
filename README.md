# 本库使用文档
## 原理介绍
针对iOS上架套壳App后台开关的问题，需要做到上架之后开关切换App界面的问题，本来打算是直接接入leancloud的iOS 原生SDK的，但是考虑到苹果对这种sdk有额外的审核，为了避过苹果对sdk的审核，所以接入的sdk并非原生的iOSsdk 而是js版本的sdk,大致原理就是通过JavaScriptCore 获取jssdk的回调


## 使用说明、使用的时候需要注意的几点
1. 导入的时候直接把Libs目录导入你的工程、需要把Libs目录的assets这个目录改为资源目录，具体做法为导入Libs目录后先删除assets（**删除的时候选择Remove Reference，删除工程引用即可不要彻底删除**），然后重新添加assets目录（**添加选项选择Create folder reference，不选Create groups**）即可，颜色必须为蓝色而非黄色!如图：![图1](https://github.com/shadow-boy/LeanCloudJSLib/blob/master/images/WechatIMG35.png) ![](https://github.com/shadow-boy/LeanCloudJSLib/blob/master/images/WechatIMG36.png)
2. 每个App需要在“WebPage.html”文件中修改三个参数、分别为“AppID”，“AppKey”，“objetctID”，如图所示：![](https://github.com/shadow-boy/LeanCloudJSLib/blob/master/images/WechatIMG37.jpeg)
3. 本库集成极光使用、手动集成极光sdk需要添加极光依赖库请参考[极光集成文档](https://docs.jiguang.cn/jpush/client/iOS/ios_guide_new/)
4. 还有就是本库采用了部分swift代码、需要对swift还有oc混编有所了解、需要在桥接文件文件添加```#import "JPUSHService.h"#import "AppDelegate.h"#import "RemoteConfigManager.h"```
5. 在`AppDelegate` return YES 之前调用`customAppeareAndData` 和 `jpushApplication: didFinishLaunchingWithOptions:`两个方法即可使用


## leancloud 后台开关配置
### [先创建一个应用](https://leancloud.cn/dashboard/applist.html#/newapp)，在里面添加`ResouceMgr`表，在表里面配置以下几个字段
1. `ios_preview_time`（Bool） -- 是否在审核之中 默认是true
2. `force_native` （Bool） -- 默认设置为false
3. `ios_preview_version`（String） -- 当前提审版本号 默认是1.0
4. `version_ios`(String) -- App Store上的当前版本号 默认1.0
5. `url_redirect`（String）-- 网页地址，即通过审核后显示的页面
6. `key_jpush`（String） -- 极光推送key。


表字段配置完毕后，需要在表内创建一个对象需要把AppID，AppKey，当期对象的objetctID三个参数填写到WebPage网页文件