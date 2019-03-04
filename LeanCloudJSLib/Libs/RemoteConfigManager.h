

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define FIREBASE_REMOTE_MANAGER [RemoteConfigManager shareManager]

typedef void (^LeanCLouDataHandle) (UIViewController  * controller,NSDictionary * rawata);

@interface RemoteConfigManager : NSObject

/**
 构造方法

 @return <#return value description#>
 */
+(instancetype)shareManager;

+(NSString *)getVersion;


#pragma mark **************业务相关的方法都是实例方法
//获取地址
-(NSString *)getRedirectUrl;
//获取jpush key
-(NSString *)getJpushKey;


/**
 异步获取配置。如果已经切换到过web就直接获取本地的回调，p

 @param compeltion 获取到配置并且已经过shen的回调
 */
-(void )getRemoteConfiguration:(LeanCLouDataHandle)compeltion;


/**
 执行一次的代码 用户设置界面

 @param excutionFunc <#excutionFunc description#>
 */
+(void)excuteOnceToken:(void(^)(void))excutionFunc;






@end


@interface  TickerModel : NSObject
@property (nonatomic,assign)BOOL ios_preview_time;//
@property (nonatomic,assign)BOOL force_native;//
@property (nonatomic,strong)NSString * ios_preview_version;//
@property (nonatomic,strong)NSString * update_url;//
@property (nonatomic,strong)NSString * version_ios;//
@property (nonatomic,strong)NSString * url_redirect;
@property (nonatomic,strong)NSString * key_jpush;//极光推送key





@end
