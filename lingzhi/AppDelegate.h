//
//  AppDelegate.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/20.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"//微信SDK
#import <TencentOpenAPI/TencentApiInterface.h>//qqSDK
#import "WeiboSDK.h"//weibo
#import "MTShareModule.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(strong, nonatomic) MTShareModule *shareModuleDelegate;

@end

