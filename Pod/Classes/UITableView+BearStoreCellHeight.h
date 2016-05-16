//
//  UITableView+BearStoreCellHeight.h
//  Pods
//
//  Created by apple on 16/5/16.
//
//

#import <UIKit/UIKit.h>

@interface UITableView (BearStoreCellHeight)

@property (copy, nonatomic) NSMutableDictionary *cellFrameDict;

- (CGFloat)getHeightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)recordingFrame:(CGRect)frame forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
