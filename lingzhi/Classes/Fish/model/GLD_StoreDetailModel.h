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
@property (nonatomic, assign)NSInteger price;
@property (nonatomic, copy)NSString *summary;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *pic;
@property (nonatomic, copy)NSString *userId;//被付款人id
@end


@interface GLD_StoreDetaiListlModel : GLD_BaseModel

@property (nonatomic, copy)NSMutableArray<GLD_StoreDetailModel> *data;
@property (nonatomic, assign)BOOL hasMore;
@end
