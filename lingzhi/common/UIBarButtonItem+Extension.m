//
//  UIBarButtonItem+Extension.m
//  TangGuoTravelLive
//
//  Created by yzq on 16/12/21.
//  Copyright © 2016年 Tango. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "TGHotsPotBtn.h"

@implementation UIBarButtonItem (Extension)

static const char *overviewKey = "ClickActionKey";

+(instancetype)barButtonWithTitle:(NSString *)title buttonSize:(CGSize)buttonSize clickAction:(void(^)())clickAction {
    TGHotsPotBtn * button = [TGHotsPotBtn buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitleColor:[YXUniversal colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    //    button.backgroundColor = [UIColor purpleColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    
    objc_setAssociatedObject(self, overviewKey, clickAction, OBJC_ASSOCIATION_COPY);
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    return item;
}

+ (void)clickButton {
    void(^clickAction)() = objc_getAssociatedObject(self, overviewKey);
    NSLog(@"clickButton");
    
    !clickAction ?: clickAction();
}

+ (instancetype)barButtonWithTitle:(NSString *)title buttonSize:(CGSize)buttonSize target:(id)target selector:(SEL)selector {
    
    if (!(title.length > 0)) {
        return nil;
    }
    
    TGHotsPotBtn * button = [TGHotsPotBtn buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitleColor:[YXUniversal colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    //    button.backgroundColor = [UIColor purpleColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    return item;
}

+ (instancetype)barButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor buttonSize:(CGSize)buttonSize target:(id)target selector:(SEL)selector {
    if (!(title.length > 0)) {
        return nil;
    }
    
    TGHotsPotBtn * button = [TGHotsPotBtn buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitleColor:[YXUniversal colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    //    button.backgroundColor = [UIColor purpleColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    return item;

}

static const char *overviewPopKey = "ClickPopActionKey";

+(instancetype)itemWithTitle:(NSString *)title imageNamed:(NSString *)imageNamed clickAction:(void (^)(void))clickAction {
    TGHotsPotBtn *button = [TGHotsPotBtn buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 44);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    //    button.backgroundColor = [UIColor greenColor];
    
    [button setTitle:@"" forState:UIControlStateNormal];
    //    if (title.length > 0)[button setTitle:title forState:UIControlStateNormal];
    //    else [button setTitle:@"" forState:UIControlStateNormal];
    
    if (imageNamed.length > 0) [button setImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
    else [button setImage:[UIImage new] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    
    objc_setAssociatedObject(self, overviewPopKey, clickAction, OBJC_ASSOCIATION_COPY);
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    return item;
    
};

+ (void)popVC {
    void(^clickAction)() = objc_getAssociatedObject(self, overviewPopKey);
    
    if (clickAction) {
        clickAction();
    }
}

+ (instancetype)barButtonLeftBackTarget:(id)target selector:(SEL)selector {
    TGHotsPotBtn *button = [TGHotsPotBtn buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 44);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    //    button.backgroundColor = [UIColor purpleColor];
    
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    return item;
}

+ (instancetype)barButtonLeftBackTarget:(id)target selector:(SEL)selector blackArrow:(BOOL)blackArrow {
    TGHotsPotBtn *button = [TGHotsPotBtn buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 44);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    //    button.backgroundColor = [UIColor purpleColor];
    
    if (blackArrow) {
        [button setImage:[UIImage imageNamed:@"header_back_icon"] forState:UIControlStateNormal];
    }else {
        [button setImage:[UIImage imageNamed:@"header_back_icon"] forState:UIControlStateNormal];
    }
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    return item;
}

+ (TGHotsPotBtn *)customBackButtonTarget:(id)target selector:(SEL)selector {
    TGHotsPotBtn *button = [TGHotsPotBtn buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 44);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [button setImage:[UIImage imageNamed:@"t_back"] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (TGHotsPotBtn *)customButton:(NSString *)normalTitle normalColor:(UIColor *)normalColor fontSize:(CGFloat)fontSize size:(CGSize)size target:(id)target selector:(SEL)selector {
    
    TGHotsPotBtn * button = [TGHotsPotBtn buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, size.width, size.height);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitle:normalTitle forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

@end
