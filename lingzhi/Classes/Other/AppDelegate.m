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
#import <AlipaySDK/AlipaySDK.h>
#import "GLD_PerfectUserMController.h"
#import "IQKeyboardManager.h"
#import "AppDelegate+JPush.h"

#define LBKeyWindow [UIApplication sharedApplication].keyWindow

#define AMAP_KEY @"963b65d551f51f9c4837ad49bb679ce7"
@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)shareDelegate {
    return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    //IQKeyboard集成
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES; // 控制整个功能是否启用。
    manager.shouldResignOnTouchOutside =YES;
    manager.enableAutoToolbar = NO;
    [self initFlashAdViewController];
    //注册微信
    [WXApi registerApp:WeiXinAppKey withDescription:@"医生汇"];
    //配置高德地图
    [AMapServices sharedServices].apiKey = AMAP_KEY;
//    [NSThread sleepForTimeInterval:3.0];
    
     [self registJpushWithApplication:application andOptions:launchOptions];
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
    
    self.window.rootViewController = tabBarVc;
    
    [self.window makeKeyAndVisible];
}
//完善信息
- (void)finishUserData{
    
    GLD_PerfectUserMController *flashAdVCtrl = [GLD_PerfectUserMController new];
    GLD_BaseNavController *rootViewController = [[GLD_BaseNavController alloc] initWithRootViewController:flashAdVCtrl background:[YXUniversal createImageWithColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE]] font:[UIFont systemFontOfSize:18.0] textColor:[YXUniversal colorWithHexString:@"fafdff"] shadowColor:[UIColor clearColor]];
    
    self.window.rootViewController = rootViewController;
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
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];;
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
//注册device token，并且绑定 Push 服务
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", deviceToken);
    
    [self registToken:deviceToken];
}
- (void)registerAPNS:(UIApplication *)application {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    NSDictionary *dic = userInfo;
    
    if (application.applicationState == UIApplicationStateActive) {
        return; //此方法 的实现 在上一步中 就是展示提示框出来
    }
    
    [self pushHandleInReception:dic];
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 打印自定义参数
    NSLog(@"Notification content is：%@", userInfo);
    NSDictionary *dic = userInfo;
    
    if (application.applicationState == UIApplicationStateActive) {
        return; //此方法 的实现 在上一步中 就是展示提示框出来
    }
    
    NSString *type = dic[@"type"];
    
    NSString *dataId = dic[@"dataId"];
    
    if (type == nil || type.length == 0 || dataId.length == 0) {
        
        // iOS badge 清0
        application.applicationIconBadgeNumber = 0;
        
        return;
    }
    [self pushHandleInReception:dic];
    application.applicationIconBadgeNumber = 0;
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    //检测是否是从推送过来的
    application.applicationIconBadgeNumber = 0;
}
- (GLD_UserMessageModel *)userModel{
    if (!_userModel) {
        _userModel = [GLD_UserMessageModel new];
    }
    return _userModel;
}
@end
