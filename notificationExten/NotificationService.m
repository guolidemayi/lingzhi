//
//  NotificationService.m
//  notificationExten
//
//  Created by 博学明辨 on 2019/10/10.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "NotificationService.h"
#import "iflyMSC/IFlyMSC.h"

@interface NotificationService ()<IFlySpeechSynthesizerDelegate>

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;


//@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;
@property (nonatomic, strong) NSMutableArray *numArrM;

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
    
    NSString *numStr = @"一千零五十点五元";
    [self.numArrM addObject:@"shop_gathering.caf"];
    for (int i = 0; i < numStr.length; i++) {
        NSRange range;
        range.length = 1;
        range.location = i;
        NSString *subStr = [numStr substringWithRange:range];

        NSString *newStr = [NSString stringWithFormat:@"tts_%@.mp3",subStr];
//        [self.numArrM addObject:newStr];
        [self.numArrM addObject:@"shop_gathering.caf"];
    }
//    [self.numArrM addObject:@"tts_ba.caf"];
    __weak __typeof(self)weakSelf = self;
    [self registerNotificationServiceType:@"" completeHandler:^{
//           weakSelf.contentHandler(weakSelf.bestAttemptContent);
       }];
   
//    [self toLocaAudio];
    
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
    
    __weak __typeof(self)weakSelf = self;
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.title = @"";
    content.subtitle = @"";
    content.body = @"";
    
    // mp3格式的也是可以的
    content.sound = [UNNotificationSound soundNamed:audioPath];
    content.categoryIdentifier = [NSString stringWithFormat:@"noti_%@",audioPath];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    UNNotificationRequest* notificationRequest =
    [UNNotificationRequest requestWithIdentifier:[NSString stringWithFormat:@"noti_%@",audioPath] content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
        if(error == nil) { 
            float time = [weakSelf audioSoundDuration:audioPath];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakSelf.numArrM.count) {
                    [weakSelf sendSoundNoti:weakSelf.numArrM.firstObject];
                }else{
                    weakSelf.contentHandler(weakSelf.bestAttemptContent);
                }
                
            });
        }
    }];
    
    
}

//合成结束
- (void) onCompleted:(IFlySpeechError *) error {

    __weak __typeof(self)weakSelf = self;
    NSString *str = self.bestAttemptContent.userInfo[@"event"];
    if ([str isEqualToString:@"ORDER"]) {
    }
   
}
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos {
    
    
}
//合成开始
- (void) onSpeakBegin {}

- (void)toLocaAudio{
//    //获取语音合成单例
//    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
//    //设置协议委托对象
//    _iFlySpeechSynthesizer.delegate = self;
//    //设置合成参数
//    //设置在线工作方式
//    [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
//     forKey:[IFlySpeechConstant ENGINE_TYPE]];
//    //设置音量，取值范围 0~100
//    [_iFlySpeechSynthesizer setParameter:@"50"
//    forKey: [IFlySpeechConstant VOLUME]];
//    //发音人，默认为”xiaoyan”，可以设置的参数列表可参考“合成发音人列表”
//    [_iFlySpeechSynthesizer setParameter:@" xiaoyan "
//     forKey: [IFlySpeechConstant VOICE_NAME]];
//    //保存合成文件名，如不再需要，设置为nil或者为空表示取消，默认目录位于library/cache下
//    [_iFlySpeechSynthesizer setParameter:@"tts.pcm"
//     forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
//    //启动合成会话
//    [_iFlySpeechSynthesizer startSpeaking: @"你好，我是科大讯飞的小燕"];
}



- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

- (float)audioSoundDuration:(NSString *)soundPath{
    
    NSDictionary *options = @{AVURLAssetPreferPreciseDurationAndTimingKey: @YES};
    
    AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:soundPath] options:options];
    
    CMTime audioDuration = audioAsset.duration;
    
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    
    return audioDurationSeconds;
    
}


- (NSMutableArray *)numArrM{
    if (!_numArrM) {
        _numArrM = [NSMutableArray array];
    }
    return _numArrM;
}
@end
