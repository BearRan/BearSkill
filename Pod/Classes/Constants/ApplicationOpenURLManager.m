//
//  ApplicationOpenURLManager.m
//  Pods
//
//  Created by apple on 16/9/18.
//
//

#import "ApplicationOpenURLManager.h"
#import "BearConstants.h"

@implementation ApplicationOpenURLManager

+ (void)openURL:(NSString *)openURL
{
    if (over_iOS10) {
         [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    else{
        NSURL *url = [NSURL URLWithString:openURL];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
