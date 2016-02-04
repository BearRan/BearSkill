//
//  BearViewController.m
//  BearSkill
//
//  Created by Bear on 02/02/2016.
//  Copyright (c) 2016 Bear. All rights reserved.
//

#import "BearViewController.h"

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
    
    [view setCenterY:100];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
