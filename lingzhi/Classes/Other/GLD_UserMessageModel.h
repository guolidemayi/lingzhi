//
//  GLD_UserMessageModel.h
//  lingzhi
//
//  Created by rabbit on 2017/12/28.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLD_BusnessModel.h"

@interface GLD_UserMessageModel : NSObject

@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *inverCode;//邀请码
@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *cashMoney;
@property (nonatomic, copy)NSString *serviceMoney;
@property (nonatomic, copy)NSString *CouponMoney;
@property (nonatomic, copy)NSString *LMoney;
@property (nonatomic, copy)NSString *mouthM;
@property (nonatomic, copy)NSString *order;//订单数
@property (nonatomic, copy)NSString *notOrder;//未处理订单数

@property (nonatomic, assign)BOOL isMember; //是否有门店
@property (nonatomic, strong) GLD_BusnessModel *busness;
@end
