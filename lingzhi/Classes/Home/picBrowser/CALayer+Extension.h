//
//  CALayer+Extension.h
//  HLFamily
//
//  Created by 博学明辨 on 2019/10/12.
//  Copyright © 2019 王卫. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (Extension)


///设置动画
/// @param duration 时间
/// @param curve 动画类型
- (void)addFadeAnimationWithDuration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve;
- (void)removePreviousFadeAnimation;
@end

NS_ASSUME_NONNULL_END
