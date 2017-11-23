//
//  GLD_BaseNavController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/20.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseNavController.h"
#import "LBTabBarController.h"
#import "UIImage+Image.h"
//黄色导航栏
#define NavBarColor [UIColor colorWithRed:250/255.0 green:227/255.0 blue:111/255.0 alpha:1.0]
@interface GLD_BaseNavController ()

@end

@implementation GLD_BaseNavController

+ (void)load
{
    
    
    UIBarButtonItem *item=[UIBarButtonItem appearanceWhenContainedIn:self, nil ];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    dic[NSForegroundColorAttributeName]=[UIColor blackColor];
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    [bar setBackgroundImage:[UIImage imageWithColor:NavBarColor] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *dicBar=[NSMutableDictionary dictionary];
    
    dicBar[NSFontAttributeName]=[UIFont systemFontOfSize:15];
    [bar setTitleTextAttributes:dic];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (id)initWithRootViewController:(UIViewController *)rootViewController background:(UIImage *)background font:(UIFont *)font textColor:(UIColor *) textColor shadowColor:(UIColor *)shadowColor
{
    
    if (self = [super initWithRootViewController:rootViewController]) {
        
        if([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
            
            [self.navigationBar setBarStyle:UIBarStyleBlackOpaque];
            //iOS 5 new UINavigationBar custom background
            [self.navigationBar setBackgroundImage:background forBarMetrics: UIBarMetricsDefault];
            
            NSShadow *shadow = [NSShadow new];
            [shadow setShadowColor: shadowColor];
            [shadow setShadowOffset: CGSizeMake(1, -1.0f)];
            //iOS 5 Setting title font.
            NSDictionary *settings;
            if (SYSTEM_VERSION <7) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
                settings = @{
                             UITextAttributeFont                 :  font,
                             UITextAttributeTextColor            :  textColor alpha:1],
                             UITextAttributeTextShadowColor      :  [UIColor clearColor],
                             UITextAttributeTextShadowOffset     :  [NSValue valueWithUIOffset:UIOffsetMake(1,-1)],
                             };
#endif
            }
            else{
                
                settings = @{
                             NSFontAttributeName                 :  font,
                             NSForegroundColorAttributeName      :  textColor,
                             NSShadowAttributeName               :  shadow,
                             };
            }
            
            [[UINavigationBar appearance] setTitleTextAttributes:settings];
            //            [self.navigationBar setTitleVerticalPositionAdjustment:2.0f forBarMetrics:UIBarMetricsDefault];
        }
    }
    return self;
}
- (void)changeStyle:(UIImage *)background font:(UIFont*) font textColor:(UIColor *)textColor shadowColor :(UIColor *)shadowColor
{
    
    [self.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    //iOS 5 new UINavigationBar custom background
    [self.navigationBar setBackgroundImage:background forBarMetrics: UIBarMetricsDefault];
    
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor: shadowColor];
    [shadow setShadowOffset: CGSizeMake(1, -1.0f)];
    //iOS 5 Setting title font.
    
    NSDictionary *settings;
    if (SYSTEM_VERSION <7) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        settings = @{
                     UITextAttributeFont                 :  font,
                     UITextAttributeTextColor            :  textColor,
                     UITextAttributeTextShadowColor      :  [UIColor clearColor],
                     UITextAttributeTextShadowOffset     :  [NSValue valueWithUIOffset:UIOffsetMake(1,-1)],
                     };
#endif
    }
    else{
        
        settings = @{
                     NSFontAttributeName                 :  font,
                     NSForegroundColorAttributeName      :  textColor,
                     NSShadowAttributeName               :  shadow,
                     };
    }
    [self.navigationBar setTitleTextAttributes:settings];
    //[self.navigationBar setTitleVerticalPositionAdjustment:2.0f forBarMetrics:UIBarMetricsDefault];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        
        
        
        
    }
    
    return [super pushViewController:viewController animated:animated];
}


@end
