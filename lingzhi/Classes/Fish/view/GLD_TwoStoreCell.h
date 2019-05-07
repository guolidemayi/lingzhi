//
//  GLD_TwoStoreCell.h
//  lingzhi
//
//  Created by 锅里的 on 2019/5/7.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_BaseCell.h"
#import "GLD_StoreDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GLD_TwoStoreCell : GLD_BaseCell
- (void)setModel1:(GLD_StoreDetailModel *)model1 andModel2:(GLD_StoreDetailModel *__nullable)model2;
@end

NS_ASSUME_NONNULL_END
