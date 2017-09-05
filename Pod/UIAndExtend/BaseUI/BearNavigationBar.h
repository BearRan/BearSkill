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

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor;
- (void)reloadNaviAttribute;

@end
