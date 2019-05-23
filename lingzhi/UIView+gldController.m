//
//  UIView+gldController.m
//  yxvzb
//
//  Created by yiyangkeji on 2017/7/3.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "UIView+gldController.h"

@implementation UIView (gldController)
- (UIViewController *)viewController {
    
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    
    return nil;
}

- (UINavigationController *)navigationController {
    return self.viewController.navigationController;
}
@end
