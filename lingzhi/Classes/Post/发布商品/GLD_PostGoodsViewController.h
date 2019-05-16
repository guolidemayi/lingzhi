//
//  GLD_PostGoodsViewController.h
//  lingzhi
//
//  Created by 锅里的 on 2019/5/16.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLD_PostGoodsViewController : GLD_BaseViewController
- (instancetype)initWith:(void (^)(void))postReloadBlock;
@end

NS_ASSUME_NONNULL_END
