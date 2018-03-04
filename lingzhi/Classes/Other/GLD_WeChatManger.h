//
//  GLD_WeChatManger.h
//  lingzhi
//
//  Created by Jin on 2018/3/4.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLD_WeChatManger : NSObject<WXApiDelegate>

@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;
@end
