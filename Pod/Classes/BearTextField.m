//
//  BearTextField.m
//  Bear
//
//  Created by Bear on 30/12/24.
//  Copyright © 2015年 Bear. All rights reserved.
//

#import "BearTextField.h"

@implementation BearTextField

//  增加限制位数的通知
- (void)addLimitLengthObserver:(int)length
{
    _limitLength = length;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(limitLengthEvent) name:UITextFieldTextDidChangeNotification object:self];
}

//  限制输入的位数
- (void)limitLengthEvent
{
    if ([self.text length] > _limitLength) {
        self.text = [self.text substringToIndex:_limitLength];
    }
}


@end
