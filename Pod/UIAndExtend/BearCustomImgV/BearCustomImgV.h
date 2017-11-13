//
//  BearCustomImgV.h
//  BiZhi
//
//  Created by Chobits on 2017/11/9.
//  Copyright © 2017年 Chobits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BearCustomImgV : UIView

@property (strong, nonatomic) UIImageView *imageView;

- (void)loadImageWithImgUrl:(NSString *)imgUrl;

@end
