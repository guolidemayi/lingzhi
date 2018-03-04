//
//  GLD_WeChatManger.m
//  lingzhi
//
//  Created by Jin on 2018/3/4.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_WeChatManger.h"

@implementation GLD_WeChatManger


#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static GLD_WeChatManger *instance;
    dispatch_once(&onceToken, ^{
        instance = [[GLD_WeChatManger alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;

}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
 if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
     
    }
    
}

@end
