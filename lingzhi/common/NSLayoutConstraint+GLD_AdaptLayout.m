//
//  NSLayoutConstraint+GLD_AdaptLayout.m
//  xiyouji
//
//  Created by Apple on 2019/7/17.
//  Copyright © 2019 Westrip. All rights reserved.
//

#import "NSLayoutConstraint+GLD_AdaptLayout.h"

@implementation NSLayoutConstraint (GLD_AdaptLayout)

//定义常量 必须是C语言字符串
static char *AdapterScreenKey = "AdapterScreenKey";

- (BOOL)adapterScreen{
    NSNumber *number = objc_getAssociatedObject(self, AdapterScreenKey);
    return number.boolValue;
}

- (void)setAdapterScreen:(BOOL)adapterScreen {
    
    NSNumber *number = @(adapterScreen);
    objc_setAssociatedObject(self, AdapterScreenKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (adapterScreen){
        self.constant = W(self.constant);
    }
}
@end
