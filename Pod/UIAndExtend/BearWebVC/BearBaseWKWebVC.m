//
//  BearBaseWKWebVC.m
//  AFNetworking
//
//  Created by Chobits on 2017/12/14.
//

#import "BearBaseWKWebVC.h"
#import "BearConstants.h"
#import <WebKit/WebKit.h>

@interface BearBaseWKWebVC ()
{
    NSString *_urlStr;
    WKWebView *_webView;
    UIProgressView *_progressView;
}
@end

@implementation BearBaseWKWebVC

- (instancetype)initWithURLStr:(NSString *)urlStr
{
    self = [super init];
    
    if (self) {
        _urlStr = urlStr;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BearConstants judgeStringExist:_urlStr]) {
        NSURL *url = [NSURL URLWithString:_urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
}

- (void)createUI
{
    //初始化一个WKWebViewConfiguration对象
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    //初始化偏好设置属性：preferences
    config.preferences = [WKPreferences new];
    //The minimum font size in points default is 0;
    config.preferences.minimumFontSize = 10;
    //是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;

    _webView = [[WKWebView alloc]initWithFrame:self.contentView.bounds configuration:config];

    [self.contentView addSubview:_webView];
}


@end
