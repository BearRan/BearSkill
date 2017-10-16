//
//  CRSectionViewUIService.h
//  BiZhi
//
//  Created by Chobits on 2017/9/18.
//  Copyright © 2017年 Chobits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^DidSelectIndexPath) (NSIndexPath *indexPath);

@interface CRSectionViewUIService : NSObject <UICollectionViewDataSource, UICollectionViewDelegate>

@property (copy, nonatomic) DidSelectIndexPath didSelectIndexPath;
@property (strong, nonatomic) NSArray *titles;

@end
