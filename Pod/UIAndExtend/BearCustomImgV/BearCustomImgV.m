//
//  BearCustomImgV.m
//  BiZhi
//
//  Created by Chobits on 2017/11/9.
//  Copyright © 2017年 Chobits. All rights reserved.
//

#import "BearCustomImgV.h"
#import "UIImageView+WebCache.h"

@interface BearCustomImgV ()
{
    NSString *_imgUrl;
}
@end

@implementation BearCustomImgV

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createUI];
    }
    
    return self;
}

- (void)createUI
{
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.backgroundColor = [UIColor whiteColor];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
}

- (void)loadImageWithImgUrl:(NSString *)imgUrl
{
    _imgUrl = imgUrl;
    
    NSData *imageData = [self imageDataFromDiskCacheWithKey:imgUrl];
    
    __weak typeof(self) weakSelf = self;
    
    if (imageData) {
        [self loadImageWithData:imageData];
    }else{
        NSURL *url = [NSURL URLWithString:imgUrl];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url
                                                              options:0
                                                             progress:nil
            completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                
                [[[SDWebImageManager sharedManager] imageCache] storeImage:image
                                                                 imageData:data
                                                                    forKey:url.absoluteString
                                                                    toDisk:YES
                                                                completion:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([imgUrl isEqualToString:_imgUrl]) {
                        [weakSelf loadImageWithData:data];
                    }
                });
            }];
    }
}

- (void)loadImageWithData:(NSData *)imageData
{
    CATransition *trainsition = [CATransition animation];
    trainsition.duration = 2.0;
    trainsition.type = kCATransitionFade;
    [_imageView.layer addAnimation:trainsition forKey:nil];
    
    UIImage *image = [UIImage imageWithData:imageData];
    _imageView.image = image;
}

- (NSData *)imageDataFromDiskCacheWithKey:(NSString *)key {
    
    NSString *path = [[[SDWebImageManager sharedManager] imageCache] defaultCachePathForKey:key];
    return [NSData dataWithContentsOfFile:path];
}

@end
