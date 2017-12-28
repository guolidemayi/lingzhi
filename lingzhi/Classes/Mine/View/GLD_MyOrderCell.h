//
//  GLD_MyOrderCell.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/28.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseCell.h"
#import "GLD_OrderModel.h"

extern NSString *const GLD_MyOrderCellIdentifier;

typedef NS_ENUM(NSInteger, callBackType) {
    callBackTypeComment,
    callBackTypeCancel
    
};

@protocol GLD_MyOrderCellDelegate <NSObject>

- (void)commentCallBack:(callBackType)type andBusnessId:(GLD_OrderModel *)busnessId;

@end

@interface GLD_MyOrderCell : GLD_BaseCell

+ (GLD_MyOrderCell *)cellWithReuseIdentifier:(NSString *)reuseIdentifier;
@property (nonatomic, strong)GLD_OrderModel *orderModel;
@property (nonatomic, weak)id<GLD_MyOrderCellDelegate> orderDelegate;
@end
