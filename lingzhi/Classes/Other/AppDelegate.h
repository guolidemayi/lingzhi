//
//  AppDelegate.h
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"//微信SDK
#import <TencentOpenAPI/TencentApiInterface.h>//qqSDK
#import "WeiboSDK.h"//weibo
#import "MTShareModule.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) MTShareModule *shareModuleDelegate;
@property (nonatomic, copy)NSString *token;//用户token
@property (nonatomic, assign)BOOL *hasLogin;//是否登陆
@property (nonatomic, strong)CLPlacemark *placemark;
- (void)initMainPageBody;
+ (AppDelegate *)shareDelegate;
@end

