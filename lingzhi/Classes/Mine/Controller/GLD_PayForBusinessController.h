//
//  GLD_PayForBusinessController.h
//  lingzhi
//
//  Created by rabbit on 2018/2/3.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseViewController.h"

@class GLD_StoreDetailModel;
@interface GLD_PayForBusinessController : GLD_BaseViewController

@property (nonatomic ,copy)NSString *payForUserId;//被付款人id
@property (nonatomic, assign)CGFloat payPrice;
@property (nonatomic, strong)GLD_StoreDetailModel *stroeModel;//
@end
