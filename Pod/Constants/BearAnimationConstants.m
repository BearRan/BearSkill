//
//  BearAnimationConstants.m
//  AFNetworking
//
//  Created by Chobits on 2019/1/2.
//

#import "BearAnimationConstants.h"
#import <UIKit/UIKit.h>

@implementation BearAnimationConstants

+ (CATransition *)trainsitionWithDefault
{
    CATransition *trainsition = [self trainsitionWithDuration:0.25 type:kCATransitionFade];
    
    return trainsition;
}

+ (CATransition *)trainsitionWithDuration:(CFTimeInterval)duration type:(CATransitionType)type
{
    CATransition *trainsition = [CATransition animation];
    trainsition.duration = duration;
    trainsition.type = type;
    
    return trainsition;
}

@end
