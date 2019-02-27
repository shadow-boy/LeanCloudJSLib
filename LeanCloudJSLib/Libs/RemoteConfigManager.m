



#import "RemoteConfigManager.h"
#import "VisualViewController.h"



static NSString * const kLocalSwithch = @"kLocalSwithch";

static RemoteConfigManager* manager =  nil;

@interface RemoteConfigManager ()

@property (nonatomic,strong)TickerModel * model;
@property (nonatomic,assign)BOOL active;

@property (nonatomic,copy)void(^tempBlock)(UIViewController * controller);/**<保存方法回调*/


@end


@implementation RemoteConfigManager

+(void)registerApp{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RemoteConfigManager alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:manager selector:@selector(getDataSuccess:) name:kLeanDataGetCompletionNotification object:nil];
        NSDictionary* object_local = [[NSUserDefaults standardUserDefaults] objectForKey:kLeanDataGetCompletionNotification];
        if (object_local){
            [[NSNotificationCenter defaultCenter] postNotificationName:kLeanDataGetCompletionNotification object:object_local];
        }
        //如果本地有数据不请求
        [DataLogicController registerWebView];

    
    });

}

+(instancetype)shareManager{
    if (manager == nil){
        [self registerApp];
    }
    return manager;
}
+(UIViewController *)cotroller{
    VisualViewController * webVc = [[VisualViewController alloc] init];
    //本地配置方式
    NSString * url = RemoteConfigManager.shareManager.getRedirectUrl;
    webVc.web_url = url;
    return webVc;
}
-(void )getRemoteConfiguration:(void(^)(UIViewController * controller))compeltion{
    self.tempBlock = compeltion;
    if (self.model){// 已经有缓存了
        
        if (![self isPreviewTimeOfiOS]){
            dispatch_async(dispatch_get_main_queue(), ^{
                VisualViewController * webVc = [[VisualViewController alloc] init];
                webVc.web_url = self.model.url_redirect;
                if (self.tempBlock){
                    self.tempBlock(webVc);
                    
                }
            });
            
        }
        
    }
}




-(void)getDataSuccess:(NSNotification*)noti{
    self.active = YES;
    NSDictionary * object = noti.object;

    if (object){
        [[NSUserDefaults standardUserDefaults] setValue:object forKey:kLeanDataGetCompletionNotification];
        self.model= [[TickerModel alloc]init];
        self.model.ios_preview_time = [object[@"ios_preview_time"] boolValue];
        self.model.ios_preview_version  = object[@"ios_preview_version"];
        self.model.force_native = [object[@"force_native"] boolValue];
        self.model.version_ios = object[@"version_ios"];
        self.model.url_redirect = object[@"url_redirect"];
        self.model.update_url = object[@"update_url"];
        self.model.key_jpush = object[@"key_jpush"];
        //没有缓存的情况
        if (![self isPreviewTimeOfiOS]){
            dispatch_async(dispatch_get_main_queue(), ^{
                VisualViewController * webVc = [[VisualViewController alloc] init];
                webVc.web_url = self.model.url_redirect;
                if (self.tempBlock){
                    self.tempBlock(webVc);
                
                }
            });
          
        }
        
        
    }
    
}

-(BOOL)isPreviewTimeOfiOS{
    //优先级1
    if ([self force_native]){
        return YES;
    }
    
    //优先级2
    if ([self haveChangeToWeb])
    {
        return NO;
    }
    
    //优先级3 开关k逻辑
    if (self.active == NO)
    {
        return YES;
    }
    
    NSString * version_current = [RemoteConfigManager getVersion];
    NSString * ios_preview_version  = self.model.ios_preview_version;
    NSString * version_ios  = self.model.version_ios;
    BOOL force_native = self.model.force_native;
    BOOL ios_preview_time = self.model.ios_preview_time;
   

    
    if (ios_preview_time && [version_current isEqualToString:ios_preview_version]){
        return YES;
    }
    [self changeToWeb];
    return NO;
    
    
}
- (void)changeToWeb{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLocalSwithch];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)haveChangeToWeb{
    BOOL b = [[NSUserDefaults standardUserDefaults] boolForKey:kLocalSwithch];
    return b;
}
-(BOOL)force_native{
    BOOL force_native = self.model.force_native;

    return force_native;
}

-(NSString *)getRedirectUrl{
    NSString * url  = self.model.url_redirect;
    return url;

}
- (NSString *)getJpushKey{
    NSString * key = self.model.key_jpush;
    if (!key){
        return @"";
    }
    return key;
}

+(NSString *)getVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appCurVersionNum;
}


+(void)excuteOnceToken:(void(^)(void))excutionFunc{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (excutionFunc){
            excutionFunc();
        }
    });
}


@end


@implementation TickerModel


@end
