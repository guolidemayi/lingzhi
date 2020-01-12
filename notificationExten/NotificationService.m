//
//  NotificationService.m
//  notificationExten
//
//  Created by 博学明辨 on 2019/10/10.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "NotificationService.h"
#import <AVFoundation/AVFoundation.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@property (nonatomic, strong) NSMutableArray *numArrM;
@property (nonatomic, assign) NSInteger index;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
//    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    
    //Set APPID
//    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"5e148089"];
    
    //Configure and initialize iflytek services.(This interface must been invoked in application:didFinishLaunchingWithOptions:)
//    [IFlySpeechUtility createUtility:initString];
    
       NSString *str = self.bestAttemptContent.userInfo[@"amount"];
       if ([str isKindOfClass:[NSString class]] && str.length > 0) {
          
           NSString *numStr = str;
           [self.numArrM addObject:@"shop_gathering.caf"];
           for (int i = 0; i < numStr.length; i++) {
               NSRange range;
               range.length = 1;
               range.location = i;
               NSString *subStr = [numStr substringWithRange:range];
               
               NSString *newStr = [NSString stringWithFormat:@"tts_%@.caf",subStr];
               [self.numArrM addObject:newStr];
           }
           [self sendSoundNoti:self.numArrM.firstObject];
       }else{
            self.contentHandler(self.bestAttemptContent);
       }
    
//    [self.numArrM addObject:@"tts_百.caf"];
//            [self.numArrM addObject:@"shop_gathering.caf"];
//    [self.numArrM addObject:@"php2VHnQz.mp3"];
    
//    __weak __typeof(self)weakSelf = self;
//    [self registerNotificationServiceType:@"" completeHandler:^{
////           weakSelf.contentHandler(weakSelf.bestAttemptContent);
//       }];
   

  
 
}

- (void)registerNotificationServiceType:(NSString*) type completeHandler:(void(^)(void))completeHandler{
    __weak __typeof(self)weakSelf = self;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error){
        
        if(granted) {
            
            [weakSelf sendSoundNoti:weakSelf.numArrM.firstObject];
            
        }
    }];
}


- (void)sendSoundNoti:(NSString *)audioPath{
    [self.numArrM removeObject:audioPath];
    self.index++;
    __weak __typeof(self)weakSelf = self;
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.title = @"";
    content.subtitle = @"";
    content.body = @"";
    
    
    
    // mp3格式的也是可以的
    content.sound = [UNNotificationSound soundNamed:audioPath];
    content.categoryIdentifier = [NSString stringWithFormat:@"noti_noti%zd",self.index++];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:.2 repeats:NO];
    UNNotificationRequest* notificationRequest =
    [UNNotificationRequest requestWithIdentifier:[NSString stringWithFormat:@"noti_noti%zd",self.index++] content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
        if(error == nil) {
            CGFloat time;
            if ([audioPath isEqualToString:@"shop_gathering.caf"]) {
                time = 3.0;
            }else{
                time = .5;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakSelf.numArrM.count) {
                    [weakSelf sendSoundNoti:weakSelf.numArrM.firstObject];
//                    weakSelf.bestAttemptContent.sound = nil;
//                    weakSelf.contentHandler(weakSelf.bestAttemptContent);
                }else{
                    weakSelf.bestAttemptContent.sound = nil;
                    weakSelf.contentHandler(weakSelf.bestAttemptContent);
                }
            });
        }
    }];
    
    
}



- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}


- (NSMutableArray *)numArrM{
    if (!_numArrM) {
        _numArrM = [NSMutableArray array];
    }
    return _numArrM;
}
@end
