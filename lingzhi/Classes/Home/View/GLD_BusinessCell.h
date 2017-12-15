//
//  GLD_BusinessCell.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/29.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseCell.h"

@class GLD_BusnessModel;
extern NSString *const GLD_BusinessCellIdentifier;

@interface GLD_BusinessCell : GLD_BaseCell

@property (nonatomic, copy)GLD_BusnessModel *model;
@end
