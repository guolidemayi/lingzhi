//
//  GLD_ExpressCell.h
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/31.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseCell.h"
#import "GLD_ExpressModel.h"

typedef NS_ENUM(NSInteger, robType){
    robTypeMyExpress,
    robTypeGetExpress,
    robTypeHasRob,
};

@protocol GLD_ExpressCellDelegate <NSObject>

- (void)robExpress:(GLD_ExpressModel *)model andType:(robType)type;
@end

@interface GLD_ExpressCell : GLD_BaseCell

@property (nonatomic, strong)GLD_ExpressModel *expressModel;
@property (nonatomic, assign)robType type;//1，抢单 2，已抢单 3 完成
@property (nonatomic, weak)id<GLD_ExpressCellDelegate> expressDelegate;
@end
