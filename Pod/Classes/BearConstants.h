//
//  BearConstants.h
//  Bear
//
//  Created by Bear on 30/12/24.
//  Copyright © 2015年 Bear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 ** UserDefaults
 **/
static NSString *udGuestId = @"guestId";          //当前用户id

#define UDGET(key)          [[NSUserDefaults standardUserDefaults] objectForKey:key]? [[NSUserDefaults standardUserDefaults] objectForKey:key] : @""
#define UDSET(value, key)   [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define UDDELETE(key)       [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];



/**
 ** Bear自定义log
 **/
#define ShowBearLog 1
#if ShowBearLog
//#define BearLog(FORMAT, ...) fprintf(stderr,"=====  Bear Log  =====\t\t%s:%d\n%s\n\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#define BearLog(FORMAT, ...) fprintf(stderr,"== Bear ==\t%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define BearLog(FORMAT, ...)
#endif



//  RGB
#define RGB(r, g, b)                [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define RGBAlpha(r, g, b, alpha)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:alpha]
#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



//  屏幕宽高
#define WIDTH ([UIScreen  mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)

//  tabbar高度
#define TABBAR_HEIGHT   self.tabBarController.tabBar.frame.size.height

//  状态栏高度
#define STATUS_HEIGHT   [[UIApplication sharedApplication] statusBarFrame].size.height

//  Navigationbar高度
#define NAVIGATIONBAR_HEIGHT self.navigationController.navigationBar.frame.size.height

//  int 转换 NSNumber
#define IntToNumber(int) [NSNumber numberWithInt:int]


@interface BearConstants : NSObject

//  获取当前时间，日期
+ (NSString *)getCurrentTimeStr;

//  dict取值并判断是否为空
+ (id)setDataWithDict:(NSDictionary *)dict keyStr:(NSString *)keyStr;

//  dict取值并判断是否为空,string类型专用
+ (NSString *)setStringWithDict:(NSDictionary *)dict keyStr:(NSString *)keyStr;

//  防止字符串为<null>
+ (NSString *)avoidStringCrash:(id)string;

//  判断字符串是否为空
+ (BOOL)judgeStringExist:(id)string;

//  判断数组里的字符串是否都存在
+ (BOOL)judgeStringExistFromArray:(NSArray *)array;

//  判断dict中是否包含某字段
+ (BOOL)judgeDictHaveStr:(NSString *)keyStr dict:(NSDictionary *)dict;

//  从URL获取图片
+ (UIImage *)getImageFromURL:(NSString *)imageURL;

//  修改iamge尺寸
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize;

//  验证姓名
+ (BOOL)validateNameString:(NSString *)nameStr;

//  验证手机号码
+ (BOOL)validatePhoneString:(NSString *)phoneStr;

/**
 *  Block Demo
 */
+ (void)requestClearMessage:(NSNumber *)notificationId success:(void (^) ())success failure:(void (^) ())failure;

@end





