//
//  AppDelegate+JPush.h
//  YX_BaseProject
//
//  Created by yiyangkeji on 2018/11/12.
//  Copyright © 2018年 com.yxvzb. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (JPush)
- (void)registToken:(NSData *)deviceToken;
- (void)registJpushWithApplication:(UIApplication *)applecation andOptions:(NSDictionary *)launchOptions;


- (void)pushHandleInReception:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
