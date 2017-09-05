//
//  BearNavigationBar.h
//

#import <UIKit/UIKit.h>

@interface BearNavigationBar : UINavigationBar

@property (nonatomic, strong) UIColor   *navBarColor;
@property (nonatomic, strong) UIColor   *titleColor;
@property (nonatomic, strong) UIFont    *titleFont;
@property (nonatomic, strong) UIColor   *sepLineColor;

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor;
- (void)setNaviBackgroundColor:(UIColor *)backgroundColor;
- (void)reloadNaviAttribute;

@end
