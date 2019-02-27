# 本库使用文档
## 原理介绍
针对iOS上架套壳App后台开关的问题，需要做到上架之后开关切换App界面的问题，本来打算是直接接入leancloud的iOS 原生SDK的，但是考虑到苹果对这种sdk有额外的审核，为了避过苹果对sdk的审核，所以接入的sdk并非原生的iOSsdk 而是js版本的sdk,大致原理就是通过JavaScriptCore 获取jssdk的回调


## 使用说明、使用的时候需要注意的几点
1. 导入的时候需要把assets这个目录改为资源目录，目录颜色必须为蓝色而非黄色!如图：![图1](https://github.com/shadow-boy/LeanCloudJSLib/blob/master/images/WechatIMG35.png) ![](https://github.com/shadow-boy/LeanCloudJSLib/blob/master/images/WechatIMG36.png)
2. 每个App需要在“WebPage.html”文件中修改三个参数、分别为“AppID”，“AppKey”，“objetctID”，如图所示：![](https://github.com/shadow-boy/LeanCloudJSLib/blob/master/images/WechatIMG37.jpeg)
3. 本库集成极光使用、手动集成极光sdk需要添加极光依赖库请参考[极光集成文档](https://docs.jiguang.cn/jpush/client/iOS/ios_guide_new/)
4. 还有就是本库采用了部分swift代码、需要对swift还有oc混编有所了解、需要在桥接文件文件添加```#import "JPUSHService.h"#import "AppDelegate.h"#import "RemoteConfigManager.h"```
5. 在`AppDelegate` return YES 之前调用`customAppeareAndData` 和 `jpushApplication: didFinishLaunchingWithOptions:`两个方法即可使用
