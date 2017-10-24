//
//  BearStringConstants.m
//  AFNetworking
//
//  Created by Chobits on 2017/10/24.
//

#import "BearStringConstants.h"

@implementation BearStringConstants

+ (NSString *)getContentFromOriginStr:(NSString *)originStr
                            prefixStr:(NSString *)prefixStr
                            suffixStr:(NSString *)suffixStr
{
    NSRange prefixRange = [originStr rangeOfString:prefixStr];
    NSRange suffixRange = [originStr rangeOfString:suffixStr];
    
    if (prefixRange.location == NSNotFound || suffixRange.location == NSNotFound) {
        return nil;
    }
    
    NSUInteger contentStrLocation = prefixRange.location + prefixStr.length;
    NSUInteger contentStrLength = suffixRange.location - contentStrLocation;
    
    NSString *contentStr = [originStr substringWithRange:NSMakeRange(contentStrLocation, contentStrLength)];
    
    return contentStr;
}

@end
