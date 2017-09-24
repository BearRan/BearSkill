//
//  BearHUDManager.h
//  Pods
//
//  Created by Chobits on 2017/9/24.
//
//

#import <Foundation/Foundation.h>

@interface BearHUDManager : NSObject 

- (instancetype)initInView:(UIView *)inView;

#pragma mark - MBProgressHUD
- (void)textStateHUD:(NSString *)text;
- (void)textStateHUD:(NSString *)text finishBlock:(void (^)())finishBlock;
- (void)showHud:(NSString *)text;
- (void)hideHUDView;

@end
