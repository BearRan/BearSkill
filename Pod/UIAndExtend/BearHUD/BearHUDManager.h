//
//  BearHUDManager.h
//  Pods
//
//  Created by Chobits on 2017/9/24.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BearHUDManager : NSObject 

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initInView:(UIView *)inView;

#pragma mark - MBProgressHUD
- (void)textStateHUD:(NSString *)text;
- (void)textStateHUD:(NSString *)text finishBlock:(void (^)())finishBlock;
- (void)showHud:(NSString *)text;
- (void)hideHUDView;

@end
