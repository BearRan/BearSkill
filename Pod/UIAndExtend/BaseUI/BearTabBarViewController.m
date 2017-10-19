//
//  BearTabBarViewController.m
//

#import "BearTabBarViewController.h"
#import "UIView+BearSet.h"
#import "BearDefines.h"
#import "UIImage-Helpers.h"

@interface BearTabBarViewController ()

@end

@implementation BearTabBarViewController

- (instancetype)initWithViewControllers:(NSMutableArray *)viewControllers
                                 titles:(NSArray *)titles
                          imageNameStrs:(NSArray *)imageNameStrs
                  imageNameSelectedStrs:(NSArray *)imageNameSelectedStrs
                              tintColor:(UIColor *)tintColor
                        backgroundColor:(UIColor *)backgroundColor
{
    return [[BearTabBarViewController alloc] initWithViewControllers:viewControllers
                                                              titles:titles
                                                       imageNameStrs:imageNameStrs
                                               imageNameSelectedStrs:imageNameSelectedStrs
                                                           tintColor:tintColor
                                                     backgroundColor:backgroundColor
                                                  tabBarItemUIOffSet:UIOffsetMake(0, -3)];
    
}

- (instancetype)initWithViewControllers:(NSMutableArray *)viewControllers
                                 titles:(NSArray *)titles
                          imageNameStrs:(NSArray *)imageNameStrs
                  imageNameSelectedStrs:(NSArray *)imageNameSelectedStrs
                              tintColor:(UIColor *)tintColor
                        backgroundColor:(UIColor *)backgroundColor
                     tabBarItemUIOffSet:(UIOffset)tabBarItemUIOffSet
{
    return [self initWithViewControllers:viewControllers
                                  titles:titles
                           imageNameStrs:imageNameStrs
                   imageNameSelectedStrs:imageNameSelectedStrs
                          imageTintColor:tintColor
                          titleTintColor:tintColor
                         backgroundColor:backgroundColor
                      tabBarItemUIOffSet:tabBarItemUIOffSet];
}

- (instancetype)initWithViewControllers:(NSMutableArray *)viewControllers
                                 titles:(NSArray *)titles
                          imageNameStrs:(NSArray *)imageNameStrs
                  imageNameSelectedStrs:(NSArray *)imageNameSelectedStrs
                         imageTintColor:(UIColor *)imageTintColor
                         titleTintColor:(UIColor *)titleTintColor
                        backgroundColor:(UIColor *)backgroundColor
                     tabBarItemUIOffSet:(UIOffset)tabBarItemUIOffSet
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        NSInteger viewControllersCount = [viewControllers count];
        NSInteger titlesCount = [titles count];
        NSInteger imageNameStrsCount = [imageNameStrs count];
        NSInteger imageNameSlectedStrsCount = [imageNameSelectedStrs count];
        BOOL correctArrayCount = ((viewControllersCount == titlesCount) &&
                                  (viewControllersCount == imageNameStrsCount) &&
                                  (viewControllersCount == imageNameSlectedStrsCount));
        if (!correctArrayCount) {
            NSLog(@"--unCorrectArrayCount");
            return self;
        }
        
        [self setViewControllers:viewControllers];
        
        UITabBar *tabBar = self.tabBar;
        if (over_iOS10) {
            tabBar.translucent = NO;
        }
        if (!backgroundColor) {
            backgroundColor = [UIColor whiteColor];
        }
        [tabBar setBackgroundImage:[UIImage imageWithColor:backgroundColor]];
        
        BOOL haveImageTintColor = imageTintColor && [imageTintColor isKindOfClass:[UIColor class]];
        BOOL haveTitleTintColor = titleTintColor && [titleTintColor isKindOfClass:[UIColor class]];
        if (haveTitleTintColor) {
            tabBar.tintColor = imageTintColor;
        }
        
        for (NSInteger i = 0; i < tabBar.items.count; i++) {
            UITabBarItem *tabBarItem = [tabBar.items objectAtIndex:i];
            [tabBarItem setImage:[[UIImage imageNamed:imageNameStrs[i]]
                                  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            
            if (haveImageTintColor) {
                [tabBarItem setSelectedImage:[[UIImage imageNamed:imageNameSelectedStrs[i]]
                                              imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            }else{
                [tabBarItem setSelectedImage:[[UIImage imageNamed:imageNameSelectedStrs[i]]
                                              imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            }
            
            tabBarItem.titlePositionAdjustment = tabBarItemUIOffSet;
            tabBarItem.title = titles[i];
        }
        
//        UIFont *titleFont = [UIFont systemFontOfSize:10];
//        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                           color_555d62, NSForegroundColorAttributeName,
//                                                           titleFont, NSFontAttributeName,
//                                                           nil] forState:UIControlStateNormal];
        if (haveTitleTintColor) {
            [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               titleTintColor, NSForegroundColorAttributeName,
                                                               nil] forState:UIControlStateHighlighted];
            [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               titleTintColor, NSForegroundColorAttributeName,
                                                               nil] forState:UIControlStateSelected];
        }
        
    }
    return self;
}

#pragma mark - UITabBarController Delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
}

@end
