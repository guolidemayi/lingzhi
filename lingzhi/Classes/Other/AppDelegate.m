//
//  AppDelegate.m
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkReachabilityManager.h"
#import "LBTabBarController.h"
#import "YXFlashAdViewController.h"
#import "WTBootPageStartViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#define LBKeyWindow [UIApplication sharedApplication].keyWindow

#define AMAP_KEY @"ec5fdec75f40817a36093df4c5fd272d"
@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)shareDelegate {
    return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];


    [self initMainPageBody];

    //配置高德地图
    [AMapServices sharedServices].apiKey = AMAP_KEY;
    return YES;
}

#pragma mark -- initView
/**
 * 欢迎页面
 */
- (void)initSplashView {
    NSString *isfirstLogin = [[NSUserDefaults standardUserDefaults] objectForKey:isFirstLogin];
    
    if (isfirstLogin == nil || isfirstLogin.length == 0) {
        //首次启动进入欢迎页
        [self gotoBootPageStartVCtrl];
        
        return;
    } else {
        //非首次启动，执行自动登录
        [self initFlashAdViewController];
    }
    
}
/**
 * 进入欢迎引导页
 */
- (void)gotoBootPageStartVCtrl {
    //进入欢迎页
    UIStoryboard *bootPageStroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WTBootPageStartViewController *bootPageStartVCtrl = (WTBootPageStartViewController *) [bootPageStroyboard instantiateViewControllerWithIdentifier:@"WTBootPageStartViewController"];

    [AppDelegate shareDelegate].window.rootViewController = bootPageStartVCtrl;
}/**
 * 进入广告页
 */
- (void)initFlashAdViewController {
    
    
    UIStoryboard *bootPageStroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YXFlashAdViewController *flashAdVCtrl = (YXFlashAdViewController *) [bootPageStroyboard instantiateViewControllerWithIdentifier:@"YXFlashAdViewController"];
GLD_BaseNavController *rootViewController = [[GLD_BaseNavController alloc] initWithRootViewController:flashAdVCtrl background:[YXUniversal createImageWithColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE]] font:[UIFont systemFontOfSize:18.0] textColor:[YXUniversal colorWithHexString:@"fafdff"] shadowColor:[UIColor clearColor]];
    
    self.window.rootViewController = rootViewController;
}

- (void)initMainPageBody{
    LBTabBarController *tabBarVc = [[LBTabBarController alloc] init];
    
    
    //    CATransition *anim = [[CATransition alloc] init];
    //    anim.type = @"rippleEffect";
    //    anim.duration = 1.0;
    //
    //
    //    [self.window.layer addAnimation:anim forKey:nil];
    
    self.window.rootViewController = tabBarVc;
    
    [self.window makeKeyAndVisible];
}
// 检测网络状态
- (void)detectionReachabilityStatus {
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            // 无网络
//            [AppDelegate shareDelegate].reachabilityStatus = 3;
            
        } else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            // wifi
//            [AppDelegate shareDelegate].reachabilityStatus = 2;
            
            
        } else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            // 移动网络
//            [AppDelegate shareDelegate].reachabilityStatus = 1;

            //            [[NSNotificationCenter defaultCenter]postNotificationName:@"ReachabilityStatusReachableViaWWAN" object:nil];
            //停止下载
        } else {
            // 未知网络
//            [AppDelegate shareDelegate].reachabilityStatus = -1;
        }
        
        
    }];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
