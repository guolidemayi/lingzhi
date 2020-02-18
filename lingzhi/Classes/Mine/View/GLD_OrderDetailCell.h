//
//  GLD_OrderDetailCell.h
//  lingzhi
//
//  Created by 博学明辨 on 2020/2/17.
//  Copyright © 2020 com.lingzhi. All rights reserved.
//

#import "GLD_BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@class GLD_OrderDetailModel;
@interface GLD_OrderDetailCell : GLD_BaseCell

@property (nonatomic, strong) GLD_OrderDetailModel *model;
@end

NS_ASSUME_NONNULL_END
