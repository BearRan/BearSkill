//
//  BearBaseViewController.m
//

#import "BearBaseViewController.h"
#import "BearHUDCustomView.h"
#import "UIView+BearSet.h"
#import "BearConstants.h"
#import "BearDefines.h"

#define MBProgressHUD_Tag       1100000

@interface BearBaseViewController () <UIGestureRecognizerDelegate>
{
    UIImageView   *   _bgImageView;
    NSArray       *   _hiddenLeftItems;
    NSArray       *   _hiddenRightItems;
}

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
    
    if (_ifTapResignFirstResponder) {
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignCurrentFirstResponder)];
        tapGR.delegate = self;
        [_contentView addGestureRecognizer:tapGR];
    }
}

- (void)refreshContentViewFrame
{
    BOOL hidesBottomBarWhenPushed = [self hidesBottomBarWhenPushed];
    CGRect viewRect = [self viewBoundsWithOrientation:self.interfaceOrientation];
    CGFloat yOffset = [self hideNavigationBarWhenPush] ? 0 : _navigationBar.height;
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
    if ( OSVersionIsAtLeastiOS7() )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        
        _contentView.frame = CGRectMake(0,
                                        _isNavBarClear ? 0 : yOffset,
                                        CGRectGetWidth(viewRect),
                                        CGRectGetHeight(viewRect) - (_isNavBarClear ? -statusHeight : (yOffset - statusHeight)) - bottomHeight);
    } else {
        _contentView.frame = CGRectMake(0,
                                        _isNavBarClear ? 0 : yOffset,
                                        CGRectGetWidth(viewRect),
                                        CGRectGetHeight(viewRect) - (_isNavBarClear ? 0 : yOffset) - bottomHeight);
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

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

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

#pragma mark - alertView
- (void)stateAlert:(NSDictionary *)alertDict
{
    if (![[alertDict objectForKey:@"title"] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:[alertDict objectForKey:@"title"]
                              message:[alertDict objectForKey:@"message"]
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:nil
                              message:[alertDict objectForKey:@"message"]
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - 背景图

- (void)setBgImg:(UIImage *)image
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:_contentView.frame];
        [_bgImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_bgImageView setClipsToBounds:YES];
        [self.view insertSubview:_bgImageView belowSubview:_contentView];
        [_contentView setBackgroundColor:[UIColor clearColor]];
    }
    [_bgImageView setImage:image];
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
        CGFloat yOffset = [self hideNavigationBarWhenPush] ? kNavigationBarHeight : 0;
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( OSVersionIsAtLeastiOS7() )
        {
            yOffset = [self hideNavigationBarWhenPush]?kNavigationBarHeight7:0;
            _navigationBar = [[BearNavigationBar alloc] initWithFrame:CGRectMake(0, 0 - yOffset, CGRectGetWidth(viewRect), kNavigationBarHeight7) backgroundColor:_backgroundColor];
        } else {
            _navigationBar = [[BearNavigationBar alloc] initWithFrame:CGRectMake(0, 0 - yOffset, CGRectGetWidth(viewRect), kNavigationBarHeight) backgroundColor:_backgroundColor];
        }
#endif
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

#pragma mark 添加按钮

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

#pragma mark - HUD Func

- (void)addHudInContentView
{
    [self.contentView bringSubviewToFront:self.stateHud];
    [self addHUDToView:self.contentView];
}

- (void)addHudInWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self addHUDToView:window];
    [window bringSubviewToFront:self.stateHud];
}

- (void)hudClean
{
    self.stateHud.detailsLabel.text = @"";
    self.stateHud.label.text = @"";
}


#pragma mark - MBProgressHUD

- (void)showHud:(NSString *)text
{
    [self addHudInContentView];
    [self hudClean];
    if ([BearConstants judgeStringExist:text]) {
        self.stateHud.label.text = text;
    }
    
    [self BearHUDLoadingAnimation];
}

- (void)addHUDToView:(UIView *)view
{
    if ([view viewWithTag:MBProgressHUD_Tag]) {
        [self.stateHud removeFromSuperview];
    }
    
    [view addSubview:self.stateHud];
}

- (void)showHudOnWindow:(NSString *)text
{
    [self addHudInWindow];
    [self hudClean];
    
    if ([BearConstants judgeStringExist:text]) {
        self.stateHud.label.text = text;
    }
    
    [self BearHUDLoadingAnimation];
}

- (void)showActivityHUD:(NSString *)text
{
    [self addHUDToView:self.contentView];
    self.stateHud.mode = MBProgressHUDModeIndeterminate;
    
    [self hudClean];
    if ([BearConstants judgeStringExist:text]) {
        self.stateHud.detailsLabel.text = text;
    }
    
    [self.stateHud showAnimated:YES];
}

- (void)textStateHUD:(NSString *)text
{
    [self addHudInContentView];
    [self hudClean];
    
    for (UIImageView *imageView in self.stateHud.subviews)
    {
        if ([imageView isKindOfClass:[UIImageView class]])
            imageView.hidden = YES;
    }
    
    if ([BearConstants judgeStringExist:text]) {
        self.stateHud.detailsLabel.text = text;
    }
    
    if (text && text.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.stateHud.mode = MBProgressHUDModeText;
            [self.stateHud showAnimated:YES];
            [self.stateHud hideAnimated:NO afterDelay:1.7f];
        });
    } else {
        [self hideHUDView];
    }
}

- (void)textStateHUD:(NSString *)text finishBlock:(void (^)())finishBlock
{
    [self textStateHUD:text];
    
    [BearConstants delayAfter:1.7 dealBlock:^{
        if (finishBlock) {
            finishBlock();
        }
    }];
}

- (void)hideHUDView
{
    [self.stateHud hideAnimated:NO afterDelay:0];
}

- (void)textStateLabel:(NSString *)text
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 8;
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.85;
    [window addSubview:bgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:label];
    [label sizeToFit];
    
    bgView.frame = CGRectMake((WIDTH-(15*2+CGRectGetWidth(label.frame)))/2.0, (HEIGHT-50)/2.0, 15*2+CGRectGetWidth(label.frame), 50);
    label.frame = CGRectMake(15, 0, CGRectGetWidth(label.frame), 50);
    
    [UIView animateWithDuration:0.4 animations:^{
        bgView.alpha = 0.85;
    }];
    
    [self performSelector:@selector(hideStateLabel:) withObject:bgView afterDelay:1.0f];
}

- (void)hideStateLabel:(UIView *)bgView
{
    [UIView animateWithDuration:0.4 animations:^{
        bgView.alpha = 0.0;
    }];
}

#pragma mark - MBProgressHUD Delegate

- (void)hudWasHidden:(MBProgressHUD *)ahud
{
    [self.stateHud removeFromSuperview];
}

- (BOOL)IsSelfTopMostOfNav
{
    return [self.navigationController.topViewController isEqual:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"disMiss" object:nil];
    
    if (_stateHud != nil) {
        //会导致循环调启
        self.stateHud.delegate = nil;
        [self.stateHud removeFromSuperview];
        self.stateHud = nil;
    }
}

#pragma mark - Setter & Getter

- (MBProgressHUD *)stateHud
{
    if (!_stateHud) {
        if (!self.view) {
            _stateHud = [[MBProgressHUD alloc] init];
        }else{
            _stateHud = [[MBProgressHUD alloc] initWithView:self.view];
            _stateHud.label.font = [UIFont systemFontOfSize:13.0f];
            _stateHud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
            _stateHud.contentColor = [UIColor whiteColor];
//            _stateHud.label.textColor = UIColorFromHEX(0xffffff);
            _stateHud.label.text = @"";
            _stateHud.detailsLabel.text = @"";
            _stateHud.detailsLabel.font = [UIFont systemFontOfSize:13.0f];
            _stateHud.detailsLabel.textColor = [UIColor whiteColor];
            _stateHud.tag = MBProgressHUD_Tag;
            
            [self.contentView addSubview:_stateHud];
        }
        _stateHud.delegate = self;
    }
    
    return _stateHud;
}

- (void)setStateHud:(MBProgressHUD *)stateHud
{
    _stateHud = stateHud;
}

- (void)BearHUDLoadingAnimation
{
    self.stateHud.mode = MBProgressHUDModeIndeterminate;
    
    [self.stateHud showAnimated:YES];
}

@end
