//
//  BearViewController.m
//  BearSkill
//
//  Created by Bear on 02/02/2016.
//  Copyright (c) 2016 Bear. All rights reserved.
//

#import "BearViewController.h"
//#import "BearSkill/BearConstants.h"
//#import <BearSkill/BearConstants.h>
//#import <Pod/BearConstants.h>

@interface BearViewController ()

@end

@implementation BearViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view];
    
    
    NSMutableArray *subViewArray = [NSMutableArray new];
    for (int i = 0; i < 6; i++) {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        view1.backgroundColor = [UIColor orangeColor];
        [view addSubview:view1];
        [subViewArray addObject:subViewArray];
    }
    
    
    
    
//    [view setCenterY:100];
//    
//    UIButton btn_1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    [btn_1 addTarget:self action:@selector(testNormal) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn_1];
//    
//    UIButton btn_2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
//    [btn_2 addTarget:self action:@selector(testUserDefine) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn_2];
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/**
 *  How to use?
 *
 *  brief Demo/简单demo
 *
 */

// - (void)testNormal
// {
// __block BearAlertView *bearAlert = [[BearAlertView alloc] init];
// 
// bearAlert.normalAlertContentView.titleLabel.text = @"温馨提示";
// bearAlert.normalAlertContentView.contentLabel.text = @"My name is Bear. Github ID is BearRan. \nThank you!";
// 
// [bearAlert alertView_ConfirmClickBlock:^{
// NSLog(@"--confirm");
// } CancelClickBlock:^{
// NSLog(@"--cancel");
// }];
// bearAlert.animationClose_FinishBlock = ^(){
// NSLog(@"--closeAniamtion finish");
// bearAlert = nil;
// };
// 
// AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
// [myDelegate.window addSubview:bearAlert];
// }





/**
 *  How to use?
 *
 *  UserDefine Demo/自定义demo
 *
 **/

// - (void)testUserDefine
// {
// 
// __block BearAlertView *bearAlert = [[BearAlertView alloc] init];
// 
// //  自定义ContentView
// UIView *tempContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 50, 200)];
// tempContentView.backgroundColor = [UIColor orangeColor];
// [bearAlert setContentView:tempContentView];
// 
// //  自定义BtnsView
// UIView *tempBtnsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tempContentView.width, 40)];
// CGFloat btn_width = floor(tempBtnsView.width / 3.0);
// CGFloat btn_height = tempBtnsView.height;
// for (int i = 0; i < 3; i++) {
// UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btn_width, btn_height)];
// btn.backgroundColor = [UIColor blueColor];
// [btn setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
// [tempBtnsView addSubview:btn];
// [btn addTarget:bearAlert action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
// 
// //  按钮点击回调
// [bearAlert alertView_SelectBtn:btn block:^{
// NSLog(@"--clickBtn:%d", i);
// }];
// }
// [UIView BearAutoLayViewArray:(NSMutableArray *)tempBtnsView.subviews layoutAxis:kLAYOUT_AXIS_X center:YES];
// [bearAlert setBtnsView:tempBtnsView];
// 
// bearAlert.animationClose_FinishBlock = ^(){
// NSLog(@"--closeAniamtion finish");
// bearAlert = nil;
// };
// 
// AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
// [myDelegate.window addSubview:bearAlert];
// }


@end
