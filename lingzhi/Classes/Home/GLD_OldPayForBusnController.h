//
//  GLD_OldPayForBusnController.h
//  lingzhi
//
//  Created by 锅里的 on 2019/5/23.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//

#import "GLD_BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLD_OldPayForBusnController : GLD_BaseViewController

@property (nonatomic ,copy)NSString *payForUserId;//被付款人id
@property (nonatomic, assign)CGFloat payPrice;
@property (nonatomic, strong)NSString *address;//邮寄地址
@end

NS_ASSUME_NONNULL_END
