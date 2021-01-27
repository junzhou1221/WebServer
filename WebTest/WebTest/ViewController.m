//
//  ViewController.m
//  WebTest
//
//  Created by jun zhou on 2021/1/25.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <GCDWebServer.h>
#import <GCDWebServerDataResponse.h>
#import <GCDWebServerURLEncodedFormRequest.h>
#import <SDWebImageManager.h>

@interface ViewController ()
@property (strong, nonatomic)  WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 300, 375, 400)];
      [self.view addSubview:_webView];
    [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2032926573,1024357327&fm=26&gp=0.jpg"] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        /*保存到沙盒  */
        NSString * path = NSHomeDirectory();
        NSString * Pathimg =[path stringByAppendingString:@"/Documents/222.png"];
        BOOL saveStatus = [UIImagePNGRepresentation(image) writeToFile:Pathimg atomically:YES];
        NSLog(@"saveStatus:%d,path:%@",saveStatus,path);//这是沙盒路径
    }];
}

- (IBAction)sss:(id)sender {
//    NSString *websitePath = [[NSBundle mainBundle] pathForResource:@"Website" ofType:nil];
    NSString *websitePath = [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),@"/Documents"];
    NSLog(@"websitePath:%@",websitePath);
    GCDWebServer *webServer = [[GCDWebServer alloc] init];
    
    //先设置个默认的handler处理静态文件（比如css、js、图片等）
    [webServer addGETHandlerForBasePath:@"/" directoryPath:websitePath indexFilename:nil cacheAge:3600 allowRangeRequests:YES];
    [webServer startWithPort:8080 bonjourName:@"GCD Web Server"];
    NSLog(@"服务启动成功，使用你的浏览器访问：%@",webServer.serverURL);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSLog(@"path=%@",path);
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:req];
}

@end
