//
//  ApplicationOpenURLManager.h
//  Pods
//
//  Created by apple on 16/9/18.
//
//

#import <Foundation/Foundation.h>

static NSString *kPrefs_Privacy = @"prefs:root=Privacy";

@interface ApplicationOpenURLManager : NSObject

+ (void)openURL:(NSString *)openURL;

@end
