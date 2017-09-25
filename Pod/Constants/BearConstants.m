//
//  BearConstants.m
//  Bear
//
//  Created by Bear on 30/12/24.
//  Copyright © 2015年 Bear. All rights reserved.
//

#import "BearConstants.h"

@implementation BearConstants

//  获取当前时间，日期
+ (NSString *)getCurrentTimeStr
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    
    return dateString;
}

//  dict取值并判断是否为空
+ (id)setDataWithDict:(NSDictionary *)dict keyStr:(NSString *)keyStr
{
    if (nil != [dict objectForKey:keyStr] && ![[dict objectForKey:keyStr] isEqual:[NSNull null]]) {
        return [dict objectForKey:keyStr];
    }
    
    return nil;
}

//  dict取值并判断是否为空,string类型专用
+ (NSString *)setStringWithDict:(NSDictionary *)dict keyStr:(NSString *)keyStr
{
    if (nil != [dict objectForKey:keyStr] && ![[dict objectForKey:keyStr] isEqual:[NSNull null]]) {
        return [NSString stringWithFormat:@"%@", [dict objectForKey:keyStr]];
    }
    
    return nil;
}

//  防止字符串为<null>
+ (NSString *)avoidStringCrash:(id)string
{
    if (string && string != nil) {
        NSString *tempStr = [NSString stringWithFormat:@"%@", string];
        if ([tempStr isEqualToString:@"<null>"]) {
            return @"";
        }
        return tempStr;
    }
    
    return @"";
}

//  判断字符串是否为空
+ (BOOL)judgeStringExist:(id)string
{
    if (string && string != nil) {
        if ([string isKindOfClass:[NSString class]]) {
            if ([string isEqualToString:@"<null>"]) {
                return NO;
            }
        }
        
        NSString *tempStr = [NSString stringWithFormat:@"%@", string];
        if ([tempStr length] > 0) {
            return YES;
        }
    }
    
    return NO;
}

//  判断数组里的字符串是否都存在
+ (BOOL)judgeStringExistFromArray:(NSArray *)array
{
    if (!array || [array count] == 0) {
        return NO;
    }
    
    for (id str in array) {
        if (![self judgeStringExist:str]) {
            return NO;
        }
    }
    
    return YES;
}

//  判断dict中是否包含某字段
+ (BOOL)judgeDictHaveStr:(NSString *)keyStr dict:(NSDictionary *)dict
{
    if ([[dict allKeys]containsObject:keyStr]&&![[dict objectForKey:keyStr] isEqual:[NSNull null]]&&[dict objectForKey:keyStr])
    {
        return YES;
    }
    
    return NO;
}

//  从URL获取图片
+ (UIImage *)getImageFromURL:(NSString *)imageURL
{
    if ([imageURL rangeOfString:@"http://"].location != NSNotFound || [imageURL rangeOfString:@"https://"].location != NSNotFound) {
        __block UIImage *image = [[UIImage alloc] init];
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        });
        return image;
    }
    
    return nil;
}

//  修改iamge尺寸
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

//  验证姓名
+ (BOOL)validateNameString:(NSString *)nameStr
{
    if ([nameStr length] > 0 && [nameStr length] < 10) {
        //數字條件
        NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
        
        //符合數字條件的有幾個字元
        NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:nameStr
                                                                           options:NSMatchingReportProgress
                                                                             range:NSMakeRange(0, nameStr.length)];
        
        if (tNumMatchCount == 0) {
            return YES;
        }
    }
    
    return NO;
}

//  验证手机号码
+ (BOOL)validatePhoneString:(NSString *)phoneStr
{
    if ([phoneStr length] == 11) {
        //數字條件
        NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
        //符合數字條件的有幾個字元
        NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:phoneStr
                                                                           options:NSMatchingReportProgress
                                                                             range:NSMakeRange(0, phoneStr.length)];
        
        if (tNumMatchCount == 11) {
            return YES;
        }
    }
    
    return NO;
}

/**
 *  Block Demo
 */
+ (void)requestClearMessage:(NSNumber *)notificationId success:(void (^) ())success failure:(void (^) ())failure
{
    
    if (success) {
        success();
    }

    if (failure) {
        failure();
    }
}

//  延时block
+ (void)delayAfter:(CGFloat)delayTime dealBlock:(void (^)())dealBlock
{
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime *NSEC_PER_SEC));
    dispatch_after(timer, dispatch_get_main_queue(), ^{
        
        if (dealBlock) {
            dealBlock();
        }
    });
}

//  获取随机颜色
+ (UIColor *)randomColor
{
    UIColor *randomColor = [self randomColorWithAlpha:1];
    return randomColor;
}

//  获取随机颜色
+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha
{
    CGFloat r = arc4random() % 255 / 255.0;
    CGFloat g = arc4random() % 255 / 255.0;
    CGFloat b = arc4random() % 255 / 255.0;
    UIColor *randomColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
    return randomColor;
}

//  获取当前页ViewController
+ (id)getCurrentViewController
{
    id result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [[(UITabBarController *)result viewControllers] objectAtIndex:[(UITabBarController *)result selectedIndex]];
    }
    
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [[(UITabBarController *)result viewControllers] objectAtIndex:[(UITabBarController *)result selectedIndex]];
    }
    
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    
    return result;
}

/***** Nav Push *****/


////  当前Tab的Nav Push VC
//+ (void)selectedTabNavPush:(id)vc
//{
//    if (vc) {
//        [(BearUINavigationController *)[[JKZJAPP_Delegate tabBarVC].viewControllers objectAtIndex:[JKZJAPP_Delegate tabBarVC].selectedIndex] pushViewController:vc animated:YES];
//    }
//}

+ (id)fetchVCWithClassName:(NSString *)className inNaviVC:(UINavigationController *)naviVC
{
    for (int i = 0; i < [naviVC.viewControllers count]; i++) {
        id tempVC = naviVC.viewControllers[i];
        Class tempClass = NSClassFromString(className);
        if ([tempVC isKindOfClass:[tempClass class]]) {
            return tempVC;
        }
    }
    
    return nil;
}

//  pop到指定的VC，如果controllers不存在该VC，pop到RootVC
+ (void)popToDestinationVC:(UIViewController *)destionationVC inVC:(UIViewController *)nowVC
{
    if (destionationVC && [nowVC.navigationController.viewControllers containsObject:destionationVC]) {
        [nowVC.navigationController popToViewController:destionationVC animated:YES];
    }
    else{
        NSLog(@"controllers不存在该VC，pop到RootVC");
        [nowVC.navigationController popToRootViewControllerAnimated:YES];
    }
}

//  pop到指定的VC，如果controllers不存在该VC，pop到RootVC
+ (void)popToDestinationVCClassName:(NSString *)destionationVCClassName inVC:(UIViewController *)nowVC
{
    for (id tempVC in nowVC.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:NSClassFromString(destionationVCClassName)]) {
            UIViewController *destinationVC = (UIViewController *)tempVC;
            [nowVC.navigationController popToViewController:destinationVC animated:YES];
            return;
        }
    }
    
    NSLog(@"controllers不存在该VC，pop到RootVC");
    [nowVC.navigationController popToRootViewControllerAnimated:YES];
}

//  pop到指定的VC，如果controllers不存在该VC，pop到RootVC
+ (BOOL)findAndpopToDestinationVCClassName:(NSString *)destionationVCClassName inVC:(UIViewController *)nowVC
{
    for (id tempVC in nowVC.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:NSClassFromString(destionationVCClassName)]) {
            UIViewController *destinationVC = (UIViewController *)tempVC;
            [nowVC.navigationController popToViewController:destinationVC animated:YES];
            return YES;
        }
    }
    
    NSLog(@"controllers不存在该VC，pop到RootVC");
    return NO;
}


//  pop到指定数量的的VC，如果num超过controllers数量，pop到RootVC
+ (void)popOverNum:(int)num inVC:(UIViewController *)nowVC
{
    NSArray *controllers = nowVC.navigationController.viewControllers;
    
    if ([controllers count] - num > 0) {
        [nowVC.navigationController popToViewController:controllers[[controllers count] - 1 - num] animated:YES];
    }else{
        NSLog(@"num超过controllers数量，pop到RootVC");
        [nowVC.navigationController popToRootViewControllerAnimated:YES];
    }
}

//  获取指定VC的相通Navi下的前一个VC
+ (id)getAheadVCInVC:(UIViewController *)inVC
{
    NSArray *controllers = inVC.navigationController.viewControllers;
    int index = (int)[controllers indexOfObject:inVC];
    
    if (index > 0) {
        UIViewController *returnController = (UIViewController *)controllers[index - 1];
        return returnController;
    }
    
    return nil;
}

//  判断是否存在字符串
+ (BOOL)theString:(NSString *)string containsString:(NSString*)other
{
    if (![[NSString class] instancesRespondToSelector:@selector(containsString:)]) {
        NSRange range = [string rangeOfString:other];
        return range.length != 0;
    }
    else
    {
        return [string containsString:other];
    }
}

/**
 *  将指定VC从Navi数组中移出
 *
 *  @param removeVC 被移除的VC，或VCname
 *  @param navVC    navVC
 */
+ (void)removeVC:(id)removeVC inNavVC:(UINavigationController *)navVC
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:navVC.viewControllers];
    if ([tempArray count] > 1) {
        
        for (int i = 0; i < [tempArray count]; i++) {
            id tempVC = tempArray[i];
            
            //  VC
            if ([removeVC isKindOfClass:[UIViewController class]]) {
                if (tempVC == removeVC) {
                    [tempArray removeObjectAtIndex:i];
                    break;
                }
            }
            
            //  String
            else if ([removeVC isKindOfClass:[NSString class]]){
                NSString *removeVCStr = (NSString *)removeVC;
                NSString *tempVCStr = NSStringFromClass([tempVC class]);
                if ([tempVCStr isEqualToString:removeVCStr]) {
                    [tempArray removeObjectAtIndex:i];
                    break;
                }
            }
            
        }
        navVC.viewControllers = tempArray;
    }
}

/**
 *  将指定VC插入到Navi数组中
 *
 *  @param insertVC 被插入的VC
 *  @param navVC    navVC
 */
+ (void)insertVC:(UIViewController *)insertVC inNavVC:(UINavigationController *)navVC atIndex:(NSInteger)index
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:navVC.viewControllers];
    
    if (index > [tempArray count]) {
        return;
    }
    
    [tempArray insertObject:insertVC atIndex:index];
    navVC.viewControllers = tempArray;
}



/** 字符串解析成字典
 *
 *  参考解析数据
 *  para_1=1&para_2=2
 */
+ (NSDictionary *)convertParaStrToDict_paraStr:(NSString *)paraStr
{
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc] init];
    
    NSArray *parasArray = [paraStr componentsSeparatedByString:@"&"];
    if (parasArray && [parasArray count] > 0) {
        for (int i = 0; i < [parasArray count]; i++) {
            
            NSString    *paraDetailStr      = parasArray[i];
            NSArray     *paraKeyValueArray  = [paraDetailStr componentsSeparatedByString:@"="];
            
            if ([paraKeyValueArray count] >= 2) {
                NSString *paraKey = paraKeyValueArray[0];
                NSString *paraValue = [[paraKeyValueArray subarrayWithRange:NSMakeRange(1, paraKeyValueArray.count - 1)] componentsJoinedByString:@"="];
                [paraDict setObject:paraValue forKey:paraKey];
            }
        }
    }
    
    return paraDict;
}

//  frame转换成bounds
+ (CGRect)convertFrameToBounds_frame:(CGRect)frame
{
    return CGRectMake(0, 0, frame.size.width, frame.size.height);
}

/**
 *  循环测试
 *
 *  @param during     循环间隔
 *  @param eventBlock block事件
 */
+ (void)loopTestDuring:(CGFloat)during eventBlock:(void (^)())eventBlock
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, during * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        
        if (false) {
            dispatch_source_cancel(timer);  //停止
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (eventBlock) {
                eventBlock();
            }
            
        });
        
    });
    dispatch_resume(timer);
}

//  imageView设置tintColor
+ (void)imageView:(UIImageView *)imageView setImage:(UIImage *)image tintColor:(UIColor *)tintColor
{
    [imageView setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    if (tintColor) {
        imageView.tintColor = tintColor;
    }
}

//  创建渐变layer
+ (CAGradientLayer *)generateGradientLayerWithRect:(CGRect)rect
                                         fromColor:(UIColor *)fromColor
                                           toColor:(UIColor *)toColor
                                              axis:(kLAYOUT_AXIS)axis
{
    //  _gradientLayer
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,
                             (__bridge id)toColor.CGColor
                             ];
    //从上往下的渐变
    //(I.e. [0,0] is the bottom-left corner of the layer, [1,1] is the top-right corner.)
    switch (axis) {
        case kLAYOUT_AXIS_Y:
        {
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(0, 1);
        }
            break;
            
        case kLAYOUT_AXIS_X:
        {
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1, 0);
        }
            break;
            
        default:
            break;
    }
    
    gradientLayer.frame = rect;
    
    return gradientLayer;
}

+ (NSDateComponents *)caculateDateDValueFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    if (fromDate && toDate) {
        // 当前日历
        NSCalendar *calendar = [NSCalendar currentCalendar];
        // 需要对比的时间数据
        NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
        | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        // 对比时间差
        NSDateComponents *dateCom = [calendar components:unit fromDate:fromDate toDate:toDate options:0];
        
        return dateCom;
    }
    
    return nil;
    
    // 伪代码
    //年差额 = dateCom.year, 月差额 = dateCom.month, 日差额 = dateCom.day, 小时差额 = dateCom.hour, 分钟差额 = dateCom.minute, 秒差额 = dateCom.second
}

//  校验数组和对应索引是否越界
+ (BOOL)validateArray:(NSArray *)array index:(NSInteger)index
{
    if (array && [array count] > index) {
        return YES;
    }
    
    return NO;
}

//  在主线程处理
+ (void)processInMainThreadWithBlock:(void (^)())block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}

+ (void)debug:(void (^)())debug release:(void (^)())release
{
#ifdef DEBUG
    if (debug) {
        debug();
    }
#else
    if (release) {
        release();
    }
#endif
}

+ (void)resignCurrentFirstResponder
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
}

//  判断是否为pad
+ (BOOL)getIsIpad
{
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"]) {
        //iPhone
        return NO;
    }
    else if([deviceType isEqualToString:@"iPod touch"]) {
        //iPod Touch
        return NO;
    }
    else if([deviceType isEqualToString:@"iPad"]) {
        //iPad
        return YES;
    }
    return NO;
}

@end




