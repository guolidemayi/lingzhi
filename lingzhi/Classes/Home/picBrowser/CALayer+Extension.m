//
//  CALayer+Extension.m
//  HLFamily
//
//  Created by 博学明辨 on 2019/10/12.
//  Copyright © 2019 王卫. All rights reserved.
//

#import "CALayer+Extension.h"


#define animationKey @"gldAnimationKey"

@implementation CALayer (Extension)


- (void)addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve {
    if (duration <= 0) return;
    
    NSString *mediaFunction;
    switch (curve) {
        case UIViewAnimationCurveEaseInOut: {
            mediaFunction = kCAMediaTimingFunctionEaseInEaseOut;
        } break;
        case UIViewAnimationCurveEaseIn: {
            mediaFunction = kCAMediaTimingFunctionEaseIn;
        } break;
        case UIViewAnimationCurveEaseOut: {
            mediaFunction = kCAMediaTimingFunctionEaseOut;
        } break;
        case UIViewAnimationCurveLinear: {
            mediaFunction = kCAMediaTimingFunctionLinear;
        } break;
        default: {
            mediaFunction = kCAMediaTimingFunctionLinear;
        } break;
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:mediaFunction];
    transition.type = kCATransitionFade;
    [self addAnimation:transition forKey:animationKey];
}
- (void)removePreviousFadeAnimation {
    [self removeAnimationForKey:animationKey];
}

@end
