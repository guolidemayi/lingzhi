//
//  UIButton+GLD_PreventDDouble.m
//  test
//
//  Created by yiyangkeji on 2018/2/8.
//  Copyright © 2018年 com.guolide. All rights reserved.
//

#import "UIButton+GLD_PreventDDouble.h"
#import <objc/runtime.h>

@implementation UIButton (GLD_PreventDDouble)

static const char *UIControl_GLD_accept = "UIControl_GLD_accept";
- (NSTimeInterval)gld_acceptEventInterval{
    return [objc_getAssociatedObject(self, UIControl_GLD_accept) doubleValue];
}

- (void)setGld_acceptEventInterval:(NSTimeInterval)gld_acceptEventInterval{
    objc_setAssociatedObject(self, UIControl_GLD_accept, @(gld_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


+ (void)load{
//    BOOL is =
//    [NSStringFromClass(self) isEqualToString:@"UIButton"];
//    if(is){
//    Method before = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
//    Method after = class_getInstanceMethod(self, @selector(gld_sendAction:to:forEvent:));
//
//    method_exchangeImplementations(before, after);
//    }
}
- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if (![self isMemberOfClass:UIButton.class]) {
        [super sendAction:action to:target forEvent:event];
        return;
    }
    if (self.gld_acceptEventInterval == 1) return;
    self.gld_acceptEventInterval = 1;
    
    [super sendAction:action to:target forEvent:event];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.gld_acceptEventInterval = 0;
    });
}
- (void)gld_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
   
    if (self.gld_acceptEventInterval == -1){
        return;
    }else if(self.gld_acceptEventInterval == 0){
        [self gld_sendAction:action to:target forEvent:event];
        return;
    }else if(self.gld_acceptEventInterval != 0){
        
        [self gld_sendAction:action to:target forEvent:event];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.gld_acceptEventInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.gld_acceptEventInterval = -1;
        });
    }
}

@end
