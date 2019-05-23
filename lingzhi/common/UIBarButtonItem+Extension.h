//
//  UIBarButtonItem+Extension.h
//  TangGuoTravelLive
//
//  Created by yzq on 16/12/21.
//  Copyright © 2016年 Tango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)


+ (instancetype)barButtonWithTitle:(NSString *)title buttonSize:(CGSize)buttonSize clickAction:(void(^)())clickAction;

+ (instancetype)barButtonWithTitle:(NSString *)title buttonSize:(CGSize)buttonSize target:(id)target selector:(SEL)selector;

+ (instancetype)itemWithTitle:(NSString *)title imageNamed:(NSString *)imageNamed clickAction:(void (^)())clickAction;

+ (instancetype)barButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor buttonSize:(CGSize)buttonSize target:(id)target selector:(SEL)selector;


/// 3.导航栏左侧返回按钮
+ (instancetype)barButtonLeftBackTarget:(id)target selector:(SEL)selector;

/**
 导航栏左侧返回按钮

 @param target target
 @param selector 事件
 @param blackArrow YES 黑色箭头 NO 白色箭头
 @return item
 */
+ (instancetype)barButtonLeftBackTarget:(id)target selector:(SEL)selector blackArrow:(BOOL)blackArrow;

+ (UIButton *)customBackButtonTarget:(id)target selector:(SEL)selector;
/// return button fast
+ (UIButton *)customButton:(NSString *)normalTitle normalColor:(UIColor *)normalColor fontSize:(CGFloat)fontSize size:(CGSize)size target:(id)target selector:(SEL)selector;

@end
