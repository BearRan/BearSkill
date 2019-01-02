//
//  BearAnimationConstants.h
//  AFNetworking
//
//  Created by Chobits on 2019/1/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BearAnimationConstants : NSObject

+ (CATransition *)trainsitionWithDefault;
+ (CATransition *)trainsitionWithDuration:(CFTimeInterval)duration type:(CATransitionType)type;

@end

NS_ASSUME_NONNULL_END
