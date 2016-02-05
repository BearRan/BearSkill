//
//  BearConstants.h
//  Bear
//
//  Created by Bear on 30/12/24.
//  Copyright © 2015年 Bear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//  NotificationCenter字段
static NSString *ConvertUserStatus = @"convertUserStatus";


//  UserDefaults字段
static NSString *udGuestId = @"guestId";          //当前用户id


/**
 *  UserDefaults
 *
 *  UDGET       获取UserDefaults数据
 *  USSET       设置UserDefaults数据
 *  UDDELETE    删除UserDefaults数据
 */
#define UDGET(key)          [[NSUserDefaults standardUserDefaults] objectForKey:key]? [[NSUserDefaults standardUserDefaults] objectForKey:key] : @""
#define UDSET(value, key)   [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define UDDELETE(key)       [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];


/**
 *  Bear自定义log
 */
#define ShowBearLog 1
#if ShowBearLog
//#define BearLog(FORMAT, ...) fprintf(stderr,"=====  Bear Log  =====\t\t%s:%d\n%s\n\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#define BearLog(FORMAT, ...) fprintf(stderr,"== Bear ==\t%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define BearLog(FORMAT, ...)
#endif


/**
 *  RGB
 */
#define RGB(r, g, b)                [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define RGBAlpha(r, g, b, alpha)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:alpha]
#define UIColorFromHEX(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


/**
 *  屏幕尺寸
 */

//  6p
#define WIDTH6P 414.0
#define HEIGHT6P 736.0

//  6（设备分辨率）
#define WIDTH6 750.0
#define HEIGHT6 1334.0

//  6（逻辑分辨率）
#define NWIDTH6 375.0
#define NHEIGHT6 667.0

//  5 | 5c | 5s
#define WIDTH5 320.0
#define HEIGHT5 568.0

//  4|4s
#define WIDTH4 320.0
#define HEIGHT4 480.0

//  屏幕宽高
#define WIDTH ([UIScreen  mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)

//  tabbar高度
#define TABBAR_HEIGHT   self.tabBarController.tabBar.frame.size.height

//  状态栏高度
#define STATUS_HEIGHT   [[UIApplication sharedApplication] statusBarFrame].size.height

//  Navigationbar高度
#define NAVIGATIONBAR_HEIGHT self.navigationController.navigationBar.frame.size.height

//  Navigationbar高度
#define NAV_44 44

//  Nav+Status
#define NAV_STA (NAVIGATIONBAR_HEIGHT + STATUS_HEIGHT)

//  Nav+Status
#define NAV44_STA (NAV_44 + STATUS_HEIGHT)

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





