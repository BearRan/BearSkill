//
//  BearBaseViewController.h
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <BearSkill/BearNavigationBar.h>

static BOOL OSVersionIsAtLeastiOS7()
{
    return (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1);
}
static const CGFloat kNavigationBarHeight       =       44.0f;
static const CGFloat kNavigationBarHeight7      =       64.0f;
static const CGFloat kStatusBarHeight           =       20.0f;
static const CGFloat kBottomBarHeight           =       49.0f;

typedef void(^ViewDidDisappearBlock)();
typedef void(^ViewWillDisappearBlock)();

@interface BearBaseViewController : UIViewController <MBProgressHUDDelegate,UINavigationBarDelegate>
{
    UIButton        *_reloadMask;
}

@property (nonatomic, strong) MBProgressHUD         *   stateHud;
@property (nonatomic, strong) BearNavigationBar       *   navigationBar;
@property (nonatomic, strong) UIView                *   contentView;
@property (nonatomic, strong) UIColor               *   navBarColor;
@property (nonatomic, strong) NSDictionary          *   vcParamsDict;
@property (nonatomic, strong) UIViewController      *   popToDestinationVC;         //跳转回指定VC
@property (nonatomic, strong) NSString              *   popToDestiantionClassName;  //跳转回指定class
@property (strong, nonatomic) BearBaseViewController  *   aheadVC;                    //从哪里跳来的VC，适用于Push和Present，便于找到上一个VC

@property (nonatomic, strong) NSString              *   imgNameBack;                //返回按钮图片名称
@property (nonatomic, strong) UIColor               *   backgroundColor;            //背景色，导航栏背景色
@property (nonatomic, strong) UIColor               *   contentViewBackgroundColor; //contentView背景色
@property (nonatomic, strong) UIColor               *   naviBackBtnTintColor;       //导航器返回按钮tintColor


@property (nonatomic, assign) BOOL                      hideNavigationBarWhenPush;
@property (nonatomic, assign) BOOL                      ifPopToRootView;
@property (nonatomic, assign) BOOL                      isNavBarClear;
@property (nonatomic, assign) BOOL                      ifAddBackButton;
@property (nonatomic, assign) BOOL                      ifDismissView;
@property (nonatomic, assign) BOOL                      ifAddPopGR;                           //  是否添加原生手势返回标记
@property (nonatomic, assign) BOOL                      ifTapResignFirstResponder;
@property (nonatomic, assign) BOOL                      removeSelfAfterDidDisappear;          //  自己消失后从navi移除

@property (nonatomic) CALayer *navBarBottomlayer;
@property (copy, nonatomic) ViewDidDisappearBlock     viewDidDisappearBlock;
@property (copy, nonatomic) ViewWillDisappearBlock    viewWillDisappearBlock;

- (instancetype)initWithParamsDict:(NSDictionary *)params;
- (void)resignCurrentFirstResponder;
- (void)createUI;
- (void)popSelf;
- (void)dismissModalViewController;
- (void)addTitleView:(UIView *)titleview;
- (UIBarButtonItem *)createBackBarButonItem;
- (void)addLeftBarButtonItem:(UIBarButtonItem *)item animation:(BOOL)animation;
- (void)addRightBarButtonItem:(UIBarButtonItem *)item animation:(BOOL)animation;
- (void)hideLeftBarButtonItemsAnimation:(BOOL)animation;
- (void)showLeftBarButtonItemsAnimation:(BOOL)animation;
- (void)hideRightBarButtonItemsAnimation:(BOOL)animation;
- (void)showRightBarButtonItemsAnimation:(BOOL)animation;
- (void)hideHUDView;
- (void)textStateHUD:(NSString *)text;
- (void)textStateHUD:(NSString *)text finishBlock:(void (^)())finishBlock;
- (void)showHud:(NSString *)text;
- (void)showHudOnWindow:(NSString *)text;
- (void)showActivityHUD:(NSString *)text;
- (void)stateAlert:(NSDictionary *)alertDict;
- (void)setBgImg:(UIImage *)image;
- (void)setExtraCellLineHidden:(UITableView *)tableView;
- (void)reloadAfterError;
- (void)textStateLabel:(NSString *)text;

- (BOOL)IsSelfTopMostOfNav;
- (void)refreshContentViewFrame;

@end
