//
//  UITextField+BearSet.m
//  Bear
//
//  Created by Bear on 30/12/24.
//  Copyright © 2015年 Bear. All rights reserved.
//

#import "UITextField+BearSet.h"

@implementation UITextField (BearSet)

//  限制输入的位数
- (void)limitLength:(int)length
{
    if ([self.text length] > length) {
        self.text = [self.text substringToIndex:length];
    }
}

@end
