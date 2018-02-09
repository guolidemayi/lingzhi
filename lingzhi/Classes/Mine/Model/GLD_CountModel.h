//
//  GLD_CountModel.h
//  lingzhi
//
//  Created by yiyangkeji on 2018/2/9.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseModel.h"

@protocol GLD_CountModel

@end

@interface GLD_CountModel : GLD_BaseModel

@property (nonatomic, copy)NSString *countId;
@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *money;
@property (nonatomic, copy)NSString *type;

@end
@interface GLD_CountDataModel : GLD_BaseModel

@property (nonatomic, copy)NSMutableArray<GLD_CountModel> *list;
@end
