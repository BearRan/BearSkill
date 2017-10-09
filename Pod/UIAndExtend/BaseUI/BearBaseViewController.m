//
//  BearBaseViewController.m
//

#import "BearBaseViewController.h"
#import "BearHUDCustomView.h"
#import "UIView+BearSet.h"
#import "BearConstants.h"
#import "BearDefines.h"
#import "BearHUDManager.h"

@interface BearBaseViewController () <UIGestureRecognizerDelegate>
{
    UIImageView   *   _bgImageView;
    NSArray       *   _hiddenLeftItems;
    NSArray       *   _hiddenRightItems;
}

@property (strong, nonatomic) BearHUDManager *hudManager;

- (CGRect)viewBoundsWithOrientation:(UIInterfaceOrientation)orientation;

@end

@implementation BearBaseViewController

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _hideNavigationBarWhenPush = NO;
        _ifPopToRootView = NO;
        _isNavBarClear = NO;
        _ifAddBackButton = YES;
        _ifDismissView = NO;
        _ifAddPopGR = YES;
        _navBarColor = nil;
        _ifTapResignFirstResponder = NO;
        _contentViewBackgroundColor = [UIColor clearColor];
        self.statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    return self;
}

- (instancetype)initWithParamsDict:(NSDictionary *)params
{
    self = [self init];
    
    if (self)
    {
        _vcParamsDict = params;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        if (self.navigationController.viewControllers.count > 1) {
            self.navigationController.interactivePopGestureRecognizer.enabled = _ifAddPopGR;
        } else {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
    
    [self navigationBar];
    [self refreshContentViewFrame];
    [_contentView setBackgroundColor:_contentViewBackgroundColor];
    [self.view addSubview:_contentView];
    
    if (over_iOS11) {
        [self.view addSubview:self.customStatusView];
    }
    
    if (_ifTapResignFirstResponder) {
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignCurrentFirstResponder)];
        tapGR.delegate = self;
        [_contentView addGestureRecognizer:tapGR];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_navigationBar)
    {
        if (_isNavBarClear) {
            [_navigationBar setTranslucent:YES]; //则状态栏及导航栏底部为透明的
        } else {
            [_navigationBar setTranslucent:NO];
        }
        
        if ([_navigationBar respondsToSelector:@selector(setShadowImage:)])
        {
            if (_navBarColor) {
                _navBarBottomlayer.hidden = YES;
            } else {
                _navBarBottomlayer.hidden = NO;
            }
        }
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        if (self.navigationController.viewControllers.count > 1) {
            self.navigationController.interactivePopGestureRecognizer.enabled = _ifAddPopGR;
        } else {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_viewWillDisappearBlock) {
        _viewWillDisappearBlock();
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_removeSelfAfterDidDisappear) {
        
        //  界面消失后，将self从self.navigationController.viewControllers中移除
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        if ([tempArray count] > 1) {
            
            for (int i = 0; i < [tempArray count]; i++) {
                id tempVC = tempArray[i];
                if (tempVC == self) {
                    [tempArray removeObjectAtIndex:i];
                    break;
                }
            }
            self.navigationController.viewControllers = tempArray;
        }
        
    }
    
    
    if (_viewDidDisappearBlock) {
        _viewDidDisappearBlock();
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissViewController) name:@"disMiss" object:nil];
}

#pragma mark - createUI

- (void)createUI
{}

#pragma mark - 返回（back）

- (void)paningGestureReceive:(id)sender
{
    [self popSelf];
}

- (void)popSelf
{
    //  _popToDestinationVC
    if (_popToDestinationVC) {
        [BearConstants popToDestinationVC:_popToDestinationVC inVC:self];
        return;
    }
    
    //  _popToDestiantionClassName
    else if (_popToDestiantionClassName && [BearConstants judgeStringExist:_popToDestiantionClassName]) {
        [BearConstants popToDestinationVCClassName:_popToDestiantionClassName inVC:self];
        return;
    }
    
    //  push
    else if (_ifPopToRootView) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    //  present
    else if (_ifDismissView) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    
    //  pop
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)dismissViewController
{
    [self.navigationController dismissViewControllerAnimated:NO completion:^{}];
}

- (void)dismissModalViewController
{
    [BearConstants resignCurrentFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - 状态栏

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - 键盘收回

- (void)resignCurrentFirstResponder
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
}

#pragma mark - navigationBar 设置

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    UINavigationItem * navItem = [[self.navigationBar items] lastObject];
    if (navItem.leftBarButtonItem == nil && [self.navigationController.viewControllers count] > 1 && self.ifAddBackButton) {
        [self addLeftBarButtonItem:[self createBackBarButonItem] animation:NO];
    }
}

- (UIBarButtonItem *)createBackBarButonItem
{
    UIButton *backBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 73/3.0, 45/3.0)];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( OSVersionIsAtLeastiOS7() ) {
        [backBarButton setFrame:CGRectMake(0, 0, 74/3.0, 74/3.0)];
    }
#endif
    
    
    if (_naviBackBtnTintColor) {
        [backBarButton setImage:[[UIImage imageNamed:_imgNameBack] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [backBarButton setTintColor:_naviBackBtnTintColor];
    }else{
        [backBarButton setImage:[UIImage imageNamed:_imgNameBack] forState:UIControlStateNormal];
    }
    
    [backBarButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 0)];
    backBarButton.adjustsImageWhenHighlighted = NO;
    [backBarButton addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    backBarButtonItem.style = UIBarButtonItemStylePlain;
    
    return backBarButtonItem;
}

- (BearNavigationBar *)navigationBar
{
    if (!_navigationBar)
    {
        CGRect viewRect = [self viewBoundsWithOrientation:self.interfaceOrientation];
        CGFloat naviHeight = NAVIGATIONBAR_HEIGHT;
        NSLog(@"--naviHeight:%f", naviHeight);
        CGFloat yOffset = [self hideNavigationBarWhenPush] ? NAV_STA : 0;
        
        _navigationBar = [[BearNavigationBar alloc] initWithFrame:CGRectMake(0, 0 - yOffset, CGRectGetWidth(viewRect), NAV_STA) backgroundColor:_backgroundColor];
        _navigationBar.navBarColor = _isNavBarClear ? [UIColor clearColor] : _navBarColor;
        _navigationBar.delegate = self;
        
        if (!_navBarBottomlayer)
        {
            _navBarBottomlayer = [CALayer layer];
            _navBarBottomlayer.frame = CGRectMake(0,_navigationBar.frame.size.height - 0.5, CGRectGetWidth(viewRect), 0.5);
            _navBarBottomlayer.backgroundColor = _isNavBarClear ? [UIColor clearColor].CGColor : _backgroundColor.CGColor;
            [_navigationBar.layer addSublayer:_navBarBottomlayer];
        }
        
        UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@""];
        [_navigationBar setItems:@[item]];
    }
    return _navigationBar;
}

#pragma mark - Get the size of view in the main screen

- (CGRect)viewBoundsWithOrientation:(UIInterfaceOrientation)orientation
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    if([[UIApplication sharedApplication] isStatusBarHidden])
    {
        if(UIInterfaceOrientationIsLandscape(orientation))
        {
            CGFloat width = bounds.size.width;
            bounds.size.width = bounds.size.height;
            bounds.size.height = width;
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            CGFloat width = bounds.size.width;
            bounds.size.width = bounds.size.height;
            bounds.size.height = width - 20;
        } else {
            bounds.size.height -= 20;
        }
    }
    return bounds;
}

#pragma mark 设置标题

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UINavigationItem * navItem = (UINavigationItem *)[[self.navigationBar items] lastObject];
    
    [navItem setTitle:title];
}

#pragma mark - Navi Item

- (void)addTitleView:(UIView *)titleview
{
    UINavigationItem *navItem = (UINavigationItem *)[[self.navigationBar items] lastObject];
    [navItem setTitleView:titleview];
}

- (void)addLeftBarButtonItem:(UIBarButtonItem *)item animation:(BOOL)animation
{
    UINavigationItem * navItem = (UINavigationItem *)[[self.navigationBar items] lastObject];
    NSArray * items = [navItem leftBarButtonItems];
    
    if (item && items && [items count]) {
        items = [items arrayByAddingObject:item];
        [navItem setLeftBarButtonItems:items animated:animation];
    } else {
        self.navigationItem.backBarButtonItem = item;
        [navItem setLeftBarButtonItem:item animated:animation];
    }
}

- (void)addRightBarButtonItem:(UIBarButtonItem *)item animation:(BOOL)animation
{
    UINavigationItem * navItem = (UINavigationItem *)[[self.navigationBar items] lastObject];
    NSArray * items = [navItem rightBarButtonItems];
    
    if (item && items && [items count]) {
        items = [items arrayByAddingObject:item];
        [navItem setRightBarButtonItems:items animated:animation];
    } else {
        [navItem setRightBarButtonItem:item animated:animation];
    }
}

- (void)hideLeftBarButtonItemsAnimation:(BOOL)animation
{
    UINavigationItem * navItem = (UINavigationItem *)[[self.navigationBar items] lastObject];
    if ([navItem leftBarButtonItems]) {
        _hiddenLeftItems = [navItem leftBarButtonItems];
    }
    [self addLeftBarButtonItem:nil animation:animation];
}

- (void)showLeftBarButtonItemsAnimation:(BOOL)animation
{
    UINavigationItem * navItem = (UINavigationItem *)[[self.navigationBar items] lastObject];
    if (_hiddenLeftItems && _hiddenLeftItems.count > 0) {
        [navItem setLeftBarButtonItems:_hiddenLeftItems animated:animation];
    }
}

- (void)hideRightBarButtonItemsAnimation:(BOOL)animation
{
    UINavigationItem * navItem = (UINavigationItem *)[[self.navigationBar items] lastObject];
    if ([navItem rightBarButtonItems]) {
        _hiddenRightItems = [navItem rightBarButtonItems];
    }
    [self addRightBarButtonItem:nil animation:animation];
}

- (void)showRightBarButtonItemsAnimation:(BOOL)animation
{
    UINavigationItem * navItem = (UINavigationItem *)[[self.navigationBar items] lastObject];
    if (_hiddenRightItems && _hiddenRightItems.count > 0) {
        [navItem setRightBarButtonItems:_hiddenRightItems animated:animation];
    }
}

#pragma mark - HUD
- (void)textStateHUD:(NSString *)text
{
    [self.hudManager textStateHUD:text];
}

- (void)textStateHUD:(NSString *)text finishBlock:(void (^)())finishBlock
{
    [self.hudManager textStateHUD:text finishBlock:^{
        if (finishBlock) {
            finishBlock();
        }
    }];
}

- (void)showHud:(NSString *)text
{
    [self.hudManager showHud:text];
}

- (void)hideHUDView
{
    [self.hudManager hideHUDView];
}

#pragma mark - Func

//  当前是否为Navi的顶层
- (BOOL)IsSelfTopMostOfNav
{
    return [self.navigationController.topViewController isEqual:self];
}

//  刷新ContentView的Frame
- (void)refreshContentViewFrame
{
    CGFloat naviYOffset = [self hideNavigationBarWhenPush] ? NAV_STA : 0;
    if (over_iOS10) {
        _navigationBar.frame = CGRectMake(0, STATUS_HEIGHT, self.view.width, NAVIGATIONBAR_HEIGHT);
    }else{
        _navigationBar.frame = CGRectMake(0, 0 - naviYOffset, self.view.width, NAV_STA);
    }
    _navBarBottomlayer.frame = CGRectMake(0,_navigationBar.frame.size.height - 0.5, self.view.width, 0.5);
    
    NSLog(@"--frame:%@", NSStringFromCGRect(_navigationBar.frame));
    
    BOOL hidesBottomBarWhenPushed = [self hidesBottomBarWhenPushed];
    CGRect viewRect = [self viewBoundsWithOrientation:self.interfaceOrientation];
    CGFloat yOffset = [self hideNavigationBarWhenPush] ? 0 : _navigationBar.maxY;
    CGFloat bottomHeight = hidesBottomBarWhenPushed ? 0 : kBottomBarHeight;
    CGFloat statusHeight = [[UIApplication sharedApplication] isStatusBarHidden] ? 0 : kStatusBarHeight;
    
    if (_hideNavigationBarWhenPush) {
        [_navigationBar removeFromSuperview];
    }else{
        [self.view addSubview:_navigationBar];
    }
    
    if (!_contentView) {
        _contentView = [UIView new];
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;

    _contentView.frame = CGRectMake(0,
                                    _isNavBarClear ? 0 : yOffset,
                                    CGRectGetWidth(viewRect),
                                    CGRectGetHeight(viewRect) - (_isNavBarClear ? -statusHeight : (yOffset - statusHeight)) - bottomHeight);
    
}

#pragma mark - Setter & Getter
- (BearHUDManager *)hudManager
{
    if (!_hudManager) {
        _hudManager = [[BearHUDManager alloc] initInView:self.contentView];
    }
    
    return _hudManager;
}

- (UIView *)customStatusView
{
    if (!_customStatusView) {
        _customStatusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, STATUS_HEIGHT)];
    }
    
    return _customStatusView;
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"disMiss" object:nil];
}

@end
