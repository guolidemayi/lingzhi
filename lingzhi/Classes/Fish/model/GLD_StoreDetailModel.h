//
//  GLD_StoreDetailModel.h
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/30.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseModel.h"

@protocol GLD_StoreDetailModel
@end
@interface GLD_StoreDetailModel : JSONModel

@property (nonatomic, copy)NSString *storeId;
@property (nonatomic, copy)NSNumber *price;
@property (nonatomic, copy)NSNumber *coupon;//优惠价格
@property (nonatomic, copy)NSNumber *count;
@property (nonatomic, copy)NSString *summary;
@property (nonatomic, copy)NSString *caregory;//所属分类
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *pic;
@property (nonatomic, copy)NSString *userId;//被付款人id
@property (nonatomic, assign) NSInteger type;//商品类型 1 兑换商品 2 特价商品 3 代金券商品
@property (nonatomic, strong) NSString *chooseNorms;//选择规格
@property (nonatomic, assign) NSInteger seleteCount;//选择数量
@property (nonatomic, copy) NSString *norms;//@","分割（规格）
@end


@interface GLD_StoreDetaiListlModel : GLD_BaseModel

@property (nonatomic, copy)NSMutableArray<GLD_StoreDetailModel> *data;
@property (nonatomic, assign)BOOL hasMore;
@end
