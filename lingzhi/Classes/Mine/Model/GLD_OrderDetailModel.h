//
//  GLD_OrderDetailModel.h
//  lingzhi
//
//  Created by 博学明辨 on 2020/2/17.
//  Copyright © 2020 com.lingzhi. All rights reserved.
//

#import "GLD_BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLD_OrderDetailModel : GLD_BaseModel

@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSNumber *prize;
@property (nonatomic, copy) NSNumber *goodscount;
@property (nonatomic, copy) NSString *goodsPic;

@end

NS_ASSUME_NONNULL_END
