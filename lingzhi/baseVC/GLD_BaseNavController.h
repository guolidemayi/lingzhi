//
//  GLD_BaseNavController.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/20.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLD_BaseNavController : UINavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController background:(UIImage *)background font:(UIFont *)font textColor:(UIColor *) textColor shadowColor:(UIColor *)shadowColor;
- (void)changeStyle:(UIImage *)background font:(UIFont*) font textColor:(UIColor *)textColor shadowColor :(UIColor *)shadowColor;
@end
