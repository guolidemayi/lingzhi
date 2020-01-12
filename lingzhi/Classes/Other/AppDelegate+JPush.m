//
//  AppDelegate+JPush.m
//  YX_BaseProject
//
//  Created by yiyangkeji on 2018/11/12.
//  Copyright © 2018年 com.yxvzb. All rights reserved.
//

#import "AppDelegate+JPush.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max

#import <UserNotifications/UserNotifications.h>

#endif
#import <AdSupport/AdSupport.h>
#import <AVFoundation/AVFoundation.h>

static NSString *appKey = @"aca375f109bc1ef82024dc22";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate (JPush)

- (void)registJpushWithApplication:(UIApplication *)applecation andOptions:(NSDictionary *)launchOptions{
    //---------极光-------------//
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]; //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
        if (@available(iOS 10.0, *)) {
            entity.types = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
        } else {
            // Fallback on earlier versions
        }
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //       categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)  categories:nil];
        
    } else {
        //categories 必须为nil
        if (@available(iOS 10.0, *)) {
            [JPUSHService registerForRemoteNotificationTypes:(UNAuthorizationOptionBadge |
                                                              UNAuthorizationOptionSound |
                                                              UNAuthorizationOptionAlert)
                                                  categories:nil];
        } else {
            // Fallback on earlier versions
        }
    }
    
    //    [JPUSHService setAlias:@"123456" callbackSelector:@selector(tiaoshi) object:self];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//        USER_Manager.deviceId = registrationID;
    }];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    if (userId.length > 0) {
        [JPUSHService setAlias:userId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"------------alias = %@-----------\n",iAlias);
        } seq:1];
    }
    [JPUSHService setBadge:0];
    
    //右上角数字图标 清0
    applecation.applicationIconBadgeNumber = 0;
}

- (void)registToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}
// iOS 10 Support 前台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    } ;
    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound|UNAuthorizationOptionBadge); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
     [self pushHandleInReception:userInfo];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler();  // 系统要求执行这个方法
//    [[GLD_PushAndBannerManager sharePushManager] pushHandle:userInfo];
    
    if ([userInfo[@"event"] isEqualToString:@"ORDER"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.window.rootViewController isMemberOfClass:NSClassFromString(@"UITabBarController")]) {
                UITabBarController *tabV = (UITabBarController *)self.window.rootViewController;
                tabV.selectedIndex = 4;
            }
        });
    }
}
- (void)pushHandleInReception:(NSDictionary *)dic{
    
//    NSError *setCategoryErr = nil;
//    [[AVAudioSession sharedInstance]
//     setCategory: AVAudioSessionCategoryPlayback
//     error: &setCategoryErr];
//    [[AVAudioSession sharedInstance]
//     setActive: YES
//     error: nil];
//    
//    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[NSString stringWithFormat:@"阿狸钱包提醒您：已收款%@元",@"100"]];
//       
//       AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
//       
//       [synth speakUtterance:utterance];
//    if ([dic[@"event"] isEqualToString:@"ORDER"]) {
//
//        [[AVAudioSession sharedInstance] setActive:YES error:nil];
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//
//        NSURL *url = [[NSBundle mainBundle] URLForResource:@"shop_gathering.caf" withExtension:nil];
//        CFURLRef urlRef = (__bridge CFURLRef)(url);
//        SystemSoundID soundID;
//        //    NSString *path = [[NSBundle mainBundle] pathForResource:@"shop_gathering" ofType:nil];
//        AudioServicesCreateSystemSoundID(urlRef, &soundID);
//        AudioServicesPlaySystemSound(soundID);
//        /*AudioServicesPlaySystemSoundWithCompletion*/
//        AudioServicesPlayAlertSoundWithCompletion(soundID, ^{
//            //            self.contentHandler(self.bestAttemptContent);
//        });
//    }
        
}
@end
