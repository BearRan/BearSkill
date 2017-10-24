//
//  BearStringConstants.m
//  AFNetworking
//
//  Created by Chobits on 2017/10/24.
//

#import "BearStringConstants.h"

@implementation BearStringConstants

// 获取prefixStr和suffixStr之间的字符串
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

// dict->string
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
