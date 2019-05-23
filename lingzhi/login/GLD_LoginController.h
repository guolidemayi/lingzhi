//
//  GLD_LoginController.h
//  yxvzb
//
//  Created by yiyangkeji on 17/2/10.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_BaseViewController.h"

@interface GLD_LoginController : GLD_BaseViewController
//微信登录需要调用绑定接口绑定手
@property (nonatomic,assign) BOOL isWechatLogin;
/**
 *  微信登录需要的参数openId
 */
@property (copy,nonatomic) NSString *openId;
/**
 *  微信登录需要的参数token
 */
@property (copy,nonatomic) NSString *token;
@end
