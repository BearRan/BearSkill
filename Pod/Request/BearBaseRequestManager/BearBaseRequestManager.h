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

- (void)getRequestWithURLStr:(NSString *)URLStr
                    paraDict:(NSDictionary *)paraDict
                successBlock:(void (^)(id responseObject))successBlock
                failureBlock:(void (^)(NSString *errorStr))failureBlock;

@end
