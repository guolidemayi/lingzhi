//
//  GLD_UserMessageModel.h
//  lingzhi
//
//  Created by rabbit on 2017/12/28.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLD_UserMessageModel : NSObject

@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *inverCode;//邀请码
@property (nonatomic, copy)NSString *userId;
@end
