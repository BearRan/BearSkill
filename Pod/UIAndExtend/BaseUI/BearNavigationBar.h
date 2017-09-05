//
//  BearNavigationBar.h
//  FenQiGuanJia
//
//  Created by 林程宇 on 15/1/23.
//  Copyright (c) 2015年 YunTu. All rights reserved.
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
