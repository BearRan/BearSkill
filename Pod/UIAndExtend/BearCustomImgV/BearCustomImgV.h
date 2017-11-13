//
//  BearCustomImgV.h
//  BiZhi
//
//  Created by Chobits on 2017/11/9.
//  Copyright © 2017年 Chobits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BearCustomImgV : UIImageView

@property (assign, nonatomic) BOOL needTrainsition;
@property (assign, nonatomic) CGFloat trainsitionDuring;

- (void)setImageWithURL:(NSURL *)imgUrl;
- (void)setImageWithURL:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage;

//注意，如果需要加Blur毛玻璃效果，建议多套一层View，再处理。
/*
- (void)createTransitionView
{
    _carouselTransitionImgV = [[BearCustomImgV alloc] initWithFrame:self.bounds];
    _carouselTransitionImgV.needTrainsition = YES;
    
    UIView *tempView = [[UIView alloc] initWithFrame:self.bounds];
    [tempView addSubview:_carouselTransitionImgV];
    [tempView blurEffectWithStyle:UIBlurEffectStyleLight Alpha:0.98];
    
    [self addSubview:tempView];
}
*/

@end
