//
//  BearErrorNetAlertManager.h
//  SuperVideo
//
//  Created by Chobits on 2017/11/13.
//  Copyright © 2017年 Chobits. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RetryClickBlock) (void);

@interface BearErrorNetAlertManager : NSObject

@property (copy, nonatomic) RetryClickBlock retryClickBlock;

- (void)show;
- (void)showWithErrorStr:(NSString *)errorStr;

@end
