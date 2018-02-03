//
//  GLD_PayForBusiCell.h
//  lingzhi
//
//  Created by rabbit on 2018/2/3.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseCell.h"

@class GLD_BusnessModel;
@protocol GLD_PayForBusiCellDelegate <NSObject>

- (void)updatePayCash:(NSString *)money;
@end
@interface GLD_PayForBusiCell : GLD_BaseCell

@property (nonatomic, strong)GLD_BusnessModel *busnessModel;
@property (nonatomic, weak)id<GLD_PayForBusiCellDelegate> payDelegate;
+ (GLD_PayForBusiCell *)cellWithReuseIdentifier:(NSString *)reuseIdentifier;
@end
