//
//  BearNavigationBar.h
//

#import <UIKit/UIKit.h>
#import "UINavigationBar+BearSet.h"

@interface BearNavigationBar : UINavigationBar

@property (nonatomic, strong) UIColor   *navBarColor;
@property (nonatomic, strong) UIColor   *titleColor;
@property (nonatomic, strong) UIFont    *titleFont;
@property (nonatomic, strong) UIColor   *sepLineColor;

@property (nonatomic, assign) BOOL   isNavBarClear;

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor;
- (void)reloadNaviAttribute;

@end
