//
//  GLD_UserMessageModel.h
//  lingzhi
//
//  Created by rabbit on 2017/12/28.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseModel.h"
#import "GLD_BusnessModel.h"

@protocol GLD_UserMessageModel

@end
@interface GLD_UserMessageModel : JSONModel

@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *inviteCode;//邀请码
@property (nonatomic, copy)NSString *userId;//
@property (nonatomic, assign)CGFloat cash;//现金
@property (nonatomic, assign)CGFloat cash1;//服务费
@property (nonatomic, assign)CGFloat cash2;//优惠券
@property (nonatomic, assign)CGFloat cash3;//k币
@property (nonatomic, copy)NSString *iconImage;//头像
@property (nonatomic, copy)NSString *company;//所在单位
@property (nonatomic, copy)NSString *sex;//性别
@property (nonatomic, copy)NSString *duty;//职位
@property (nonatomic, copy)NSString *industry;//行业
@property (nonatomic, assign)NSInteger Order1;//未处理订单数
@property (nonatomic, copy)NSString *birthDay;//生日
@property (nonatomic, copy)NSString *city;//城市
@property (nonatomic, copy)NSString *area;//区
@property (nonatomic, assign)BOOL isHasBusness; //是否有门店
@property (nonatomic, copy)NSString *intro;//简介
@property (nonatomic, copy)NSString *name;//昵称
@property (nonatomic, copy)NSString *identityId;//身份证号
@property (nonatomic, assign)NSInteger Order;//订单数
@property (nonatomic, copy)NSString *address;//详细地址
@property (nonatomic, copy)NSString *loginToken;
@property (nonatomic, copy)NSString *code;//编号
@property (nonatomic, copy)NSString *VeryMsg;//认证错误信息
@property (nonatomic, copy)NSString *Very;//市民认证状态
@property (nonatomic, assign)CGFloat Profit;//月收益
@property (nonatomic, assign)CGFloat dayCash;//日收益
/**
 * 0:未注册渠道商
 * 1：未审核
 * 2：已审核
 * */

@property (nonatomic, assign)NSInteger channelUserStatus;
@property (nonatomic, assign)NSInteger proxyUserStatus;// * 0:未注册代理商* 1：未审核* 2：已审核


@end

@interface GLD_UserModel : GLD_BaseModel

@property (nonatomic, strong) GLD_UserMessageModel *data;
@end
