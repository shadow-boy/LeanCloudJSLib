
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#define  kLeanDataGetCompletionNotification  @"kLeanDataGetCompletionNotification"

@interface VisualViewController : UIViewController

@property (strong, nonatomic)  UIWebView *webView;
@property (nonatomic,strong)NSString *  web_url;/**<通过setter 调用设置web 指向*/


@property (nonatomic,assign)BOOL isLand;

@end


@interface DataLogicController :UIViewController

/**
 必须执行。。注册

 @return <#return value description#>
 */
+(instancetype)registerWebView;

@end




@protocol JSFKProtocol <JSExport>
//获取到对象的回调
-(void)getLeanCloudObjectSuccess:(NSDictionary *)object;
@end


@interface JSFKProtocolModel : NSObject <JSFKProtocol>
@property (nonatomic,strong)JSContext * context;


@end
