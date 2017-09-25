//
//  BearTabBarViewController.h
//

#import <UIKit/UIKit.h>

@interface BearTabBarViewController : UITabBarController

- (instancetype)initWithViewControllers:(NSMutableArray *)viewControllers
                                 titles:(NSArray *)titles
                          imageNameStrs:(NSArray *)imageNameStrs
                  imageNameSelectedStrs:(NSArray *)imageNameSelectedStrs
                              tintColor:(UIColor *)tintColor
                        backgroundColor:(UIColor *)backgroundColor;

- (instancetype)initWithViewControllers:(NSMutableArray *)viewControllers
                                 titles:(NSArray *)titles
                          imageNameStrs:(NSArray *)imageNameStrs
                  imageNameSelectedStrs:(NSArray *)imageNameSelectedStrs
                              tintColor:(UIColor *)tintColor
                        backgroundColor:(UIColor *)backgroundColor
                     tabBarItemUIOffSet:(UIOffset)tabBarItemUIOffSet;

@end
