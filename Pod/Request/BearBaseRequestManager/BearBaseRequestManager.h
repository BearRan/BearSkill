//
//  BearBaseRequestManager.h
//  BiZhi
//
//  Created by Chobits on 2017/9/19.
//  Copyright © 2017年 Chobits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BearBaseResponseVO.h"

@interface BearBaseRequestManager : NSObject

// Default Yes
@property (assign, nonatomic) BOOL autoAddAgent;

- (void)getRequestWithURLStr:(NSString *)URLStr
                    paraDict:(NSDictionary *)paraDict
                successBlock:(void (^)(id responseObject))successBlock
                failureBlock:(void (^)(NSString *errorStr))failureBlock;

- (void)postRequestWithURLStr:(NSString *)URLStr
                     paraDict:(NSDictionary *)paraDict
                 successBlock:(void (^)(id responseObject))successBlock
                 failureBlock:(void (^)(NSString *errorStr))failureBlock;

#pragma mark - 自定义Request
- (void)customRequestWithRequest:(NSMutableURLRequest *)request
                    successBlock:(void (^)(id responseObject))successBlock
                    failureBlock:(void (^)(NSString *errorStr))failureBlock;

- (NSMutableURLRequest *)generateRequestWithURLStr:(NSString *)urlStr
                                          paraDict:(NSDictionary *)paraDict;

- (void)getRequestWithRequest:(NSMutableURLRequest *)request
                 successBlock:(void (^)(id responseObject))successBlock
                 failureBlock:(void (^)(NSString *errorStr))failureBlock;
@end
