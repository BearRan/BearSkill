//
//  BearBaseWKWebVC.h
//  AFNetworking
//
//  Created by Chobits on 2017/12/14.
//

#import <BearSkill/BearBaseViewController.h>
#import <WebKit/WebKit.h>

@interface BearBaseWKWebVC : BearBaseViewController

@property (strong, nonatomic) WKWebViewConfiguration *config;

- (instancetype)initWithURLStr:(NSString *)urlStr;
- (instancetype)initWithURLStr:(NSString *)urlStr paraDict:(NSDictionary *)paraDict;

@end