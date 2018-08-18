//
//  GLD_GoodsDetailController.h
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/30.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseViewController.h"

@class GLD_StoreDetailModel;
@interface GLD_GoodsDetailController : GLD_BaseViewController

@property (nonatomic, strong)GLD_StoreDetailModel *storeModel;
@property (nonatomic, assign) NSInteger type;//商品类型 1 兑换商品 2 特价商品 3 代金券商品
@end
