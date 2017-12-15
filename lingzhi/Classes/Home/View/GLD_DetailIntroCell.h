//
//  GLD_DetailIntroCell.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseCell.h"

@class GLD_BusnessModel;
extern NSString *const GLD_DetailIntroCellIdentifier;
@interface GLD_DetailIntroCell : GLD_BaseCell

@property (nonatomic, strong)GLD_BusnessModel *busnessModel;
@end
