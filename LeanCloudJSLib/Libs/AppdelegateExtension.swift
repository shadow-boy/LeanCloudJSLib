

import Foundation
import UserNotifications


extension AppDelegate:JPUSHRegisterDelegate{
    
  @objc  public func customAppeareAndData (){

    RemoteConfigManager.share()?.getRemoteConfiguration({ (controller) in
        if ((controller) != nil){
            RemoteConfigManager.excuteOnceToken({
              
                self.window.rootViewController = controller;
                
            })
            
        }
        
    })
    
    
    
    }
    
    /// 注册jpush推送。
    ///
    /// - Parameters:
    ///   - application: <#application description#>
    ///   - launchOptions: <#launchOptions description#>
  @objc  func jpushApplication(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Void {
        UIApplication.shared.applicationIconBadgeNumber = 0;
        let entity = JPUSHRegisterEntity();
        
        entity.types = Int(JPAuthorizationOptions.alert.rawValue|JPAuthorizationOptions.badge.rawValue|JPAuthorizationOptions.sound.rawValue);
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self as! JPUSHRegisterDelegate);
        
        

        
        // Required
        //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
        JPUSHService .setup(withOption: launchOptions, appKey: RemoteConfigManager.share()?.getJpushKey(), channel: "", apsForProduction: true)
        
    }
    
    
    
    // MARK: -
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    @available(iOS 10.0, *)
    public func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo:[AnyHashable:Any] = response.notification.request.content.userInfo
        if let _:UNPushNotificationTrigger = response.notification.request.trigger as? UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    public func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo:[AnyHashable:Any] = notification.request.content.userInfo
        
        if let _:UNPushNotificationTrigger = notification.request.trigger as? UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
}
