//
//  BearNavigationBar.m
//

#import "BearNavigationBar.h"
#import "UIImage-Helpers.h"
#import "UIView+BearSet.h"
#import "BearDefines.h"

@interface BearNavigationBar ()

@property (strong, nonatomic) UIView  *sepLineView;

@end

@implementation BearNavigationBar

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _titleColor = [UIColor whiteColor];
        _titleFont = [UIFont boldSystemFontOfSize:18];
        
        [self reloadNaviAttribute];
        [self setNaviBackgroundColor:backgroundColor];
        
        self.shadowImage = [[UIImage alloc] init];
    }
    return self;
}

- (void)setNaviBackgroundColor:(UIColor *)backgroundColor
{
    if (backgroundColor) {
        [self setBackgroundImage:[UIImage imageWithColor:backgroundColor] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)setNavBarColor:(UIColor *)navBarColor andNavTextColor:(UIColor *)navTextColor
{
    _navBarColor = navBarColor;
    
    if (_navBarColor)
    {
        [self setBackgroundImage:[UIImage imageWithColor:_navBarColor] forBarMetrics:UIBarMetricsDefault];
        self.shadowImage = [[UIImage alloc] init];
    }
    
    // 导航栏 字体、颜色
    //原借款专家色值 #define navTextColor UIColorFromHEX(0x000000)
    if (navTextColor) {
        _titleColor = navTextColor;
    }
    
    [self reloadNaviAttribute];
}

- (void)reloadNaviAttribute
{
    // 导航栏 字体、颜色
    NSDictionary *attrs = @{ NSForegroundColorAttributeName:_titleColor,
                             NSFontAttributeName:_titleFont,
                             NSShadowAttributeName:[[NSShadow alloc] init]};
    [self setTitleTextAttributes:attrs];
}

//  解决NavigationBar按钮点击，相应范围过大的问题
//  参考：http://blog.csdn.net/shaobo8910/article/details/45057051
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self pointInside:point withEvent:event]) {
        self.userInteractionEnabled = YES;
    }else{
        self.userInteractionEnabled = NO;
    }
    
    return [super hitTest:point withEvent:event];
}


#pragma mark - Rewrite

@synthesize sepLineColor = _sepLineColor;

- (void)setSepLineColor:(UIColor *)sepLineColor
{
    _sepLineColor = sepLineColor;
    
    self.sepLineView.backgroundColor = _sepLineColor;
}


@synthesize sepLineView = _sepLineView;

- (UIView *)sepLineView
{
    if (!_sepLineView) {
        _sepLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
        [self addSubview:_sepLineView];
        [_sepLineView BearSetRelativeLayoutWithDirection:kDIR_DOWN destinationView:nil parentRelation:YES distance:0 center:YES];
    }
    
    return _sepLineView;
}

@end
