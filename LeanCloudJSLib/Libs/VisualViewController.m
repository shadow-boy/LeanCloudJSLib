

#import "VisualViewController.h"
#import "RemoteConfigManager.h"

@interface VisualViewController ()<UIWebViewDelegate>

@end

@implementation VisualViewController

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    
}
- (void)setWeb_url:(NSString *)web_url{
    _web_url = web_url;
    NSString * url = web_url;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:request];
    
    
}


-(UIWebView *)webView{
    if (!_webView){
        _webView = [[UIWebView alloc]initWithFrame:UIScreen.mainScreen.bounds];
        _webView.backgroundColor = UIColor.whiteColor;
        _webView.scalesPageToFit = NO;
        _webView.opaque = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.bounces = NO;
        if (@available(iOS 11, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _webView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    //    [self.view addSubview:self.webView];
    
    
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.view addSubview:self.webView];
    }
    return self;
}
- (void)viewWillLayoutSubviews{
    NSLog(@"self.view.frame ---- %@",NSStringFromCGRect(self.view.frame));
    NSLog(@"self.webView.frame ---- %@",NSStringFromCGRect(self.webView.frame));
    
    
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}


#pragma mark ---页面销毁
-(void)dealloc{
    //    [self evaluteWithFuncName:@"onDestroy" paramters:nil];
    self.webView.delegate = nil;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end




static DataLogicController * _instance_web = nil;

@interface DataLogicController()<UIWebViewDelegate>
@property (strong, nonatomic)  UIWebView *webView;
@property (strong, nonatomic) JSContext *context;

@end
@implementation DataLogicController
- (void)viewDidLoad{
    [super viewDidLoad];
}
+ (instancetype)registerWebView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance_web = [[DataLogicController alloc] init];
        [_instance_web setupView];
    });
    return _instance_web;
}

#pragma  mark ----加载web
- (void)loadDataFile
{
    NSString * fileurl = [[NSBundle mainBundle] pathForResource:@"WebPage" ofType:@"html" inDirectory:@"assets"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileurl]];
    [self.webView loadRequest:request];
    
}
-(void)setupView{
    self.webView = [[UIWebView alloc]initWithFrame:UIScreen.mainScreen.bounds];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    //    self.webView.hidden = YES;
    [self loadDataFile];
    
}
-(void) webViewDidStartLoad:(UIWebView *)webView{
    //    self.context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //    JSFKProtocolModel* model = [[JSFKProtocolModel alloc]init];
    //    model.context = self.context;
    //    self.context[@"_A"] = model;
    //    NSString * func = [NSString stringWithFormat:@"_registeraApp"];
    //    JSValue * funcValue =  self.context[func];
    //    [funcValue  callWithArguments:@[]];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    JSFKProtocolModel* model = [[JSFKProtocolModel alloc]init];
    model.context = self.context;
    self.context[@"_A"] = model;
    NSString * func = [NSString stringWithFormat:@"_registeraApp"];
    JSValue * funcValue =  self.context[func];
    [funcValue  callWithArguments:@[]];
}



@end





@implementation JSFKProtocolModel

- (void)getLeanCloudObjectSuccess:(NSDictionary *)object{
    [[NSNotificationCenter defaultCenter] postNotificationName:kLeanDataGetCompletionNotification object:object];
}


@end
