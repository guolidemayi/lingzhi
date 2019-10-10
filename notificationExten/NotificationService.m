//
//  NotificationService.m
//  notificationExten
//
//  Created by 博学明辨 on 2019/10/10.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
//    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    
    __weak __typeof(self)weakSelf = self;
    NSString *str = self.bestAttemptContent.userInfo[@"event"];
    if ([str isEqualToString:@"ORDER"]) {
        [self registerNotificationServiceType:@"" completeHandler:^{
            weakSelf.contentHandler(weakSelf.bestAttemptContent);
        }];
    }
   
    
}

- (void)registerNotificationServiceType:(NSString*) type completeHandler:(void(^)(void))completeHandler{
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error){
        
        if(granted) {
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
            content.title = @"";
            content.subtitle = @"";
            content.body = @"";
            
            // mp3格式的也是可以的
            content.sound = [UNNotificationSound soundNamed:[NSString stringWithFormat:@"shop_gathering.caf"]];
            content.categoryIdentifier = [NSString stringWithFormat:@"noti_%@",type];
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
            UNNotificationRequest* notificationRequest =
            [UNNotificationRequest requestWithIdentifier:[NSString stringWithFormat:@"noti_%@",type] content:content trigger:trigger];
            [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
                if(error == nil) {
                    completeHandler();
                }
            }];
        }
    }];
}


- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
