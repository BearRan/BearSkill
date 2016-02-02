//
//  BearTextField.h
//  Bear
//
//  Created by Bear on 30/12/24.
//  Copyright © 2015年 Bear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BearTextField : UITextField

@property (assign, nonatomic) int limitLength;

//  增加限制位数的通知
- (void)addLimitLengthObserver:(int)length;

@end
