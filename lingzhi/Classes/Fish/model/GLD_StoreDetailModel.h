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
@property (nonatomic, assign)NSInteger storePrice;
@property (nonatomic, copy)NSString *storeDetail;
@property (nonatomic, copy)NSString *storeName;
@property (nonatomic, copy)NSString *storeImg;
@property (nonatomic, copy)NSString *payUserId;//被付款人id
@end


@interface GLD_StoreDetaiListlModel : GLD_BaseModel

@property (nonatomic, copy)NSMutableArray<GLD_StoreDetailModel> *list;
@property (nonatomic, assign)BOOL hasMore;
@end
