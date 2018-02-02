//
//  GLD_PayRechargeController.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/13.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseViewController.h"

@interface GLD_PayRechargeController : GLD_BaseViewController

@property (nonatomic, assign)NSInteger isQRCode;//1 扫描支付。0 充值
@property (nonatomic, copy)NSString *payForUserId;//被付款人id

@end
