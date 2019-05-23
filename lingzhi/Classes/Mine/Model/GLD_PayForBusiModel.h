//
//  GLD_PayForBusiModel.h
//  lingzhi
//
//  Created by rabbit on 2018/2/3.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseModel.h"
#import "GLD_BusnessModel.h"

@interface GLD_PayForBusiMainModel : GLD_BaseModel

@property (nonatomic, copy) NSString *distance;//距离
@property (nonatomic, copy) NSString *evaluateScore;//等级
@property (nonatomic, copy) NSString *isCollect;//收藏
@property (nonatomic, copy) NSString *isOpenRebate;//
@property (nonatomic, copy) NSString *category;//所属行业
@property (nonatomic, copy)NSString *busnessType; //1高级  2普通
@end

@interface GLD_PayForBusiModel : GLD_BaseModel
@property (nonatomic, strong) GLD_BusnessModel *shop;
@property (nonatomic, copy) NSString *coupon;//代金券
@property (nonatomic, copy) NSString *discount;//折扣比例
@property (nonatomic, copy) NSString *cash;//服务费

@end
