//
//  GLD_ExpressModel.h
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/31.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseModel.h"

@protocol GLD_ExpressModel

@end
@interface GLD_ExpressModel : JSONModel

@property (nonatomic, copy)NSString *fromAdress;
@property (nonatomic, copy)NSString *expressId;
@property (nonatomic, copy)NSString *toAdress;
@property (nonatomic, copy)NSString *tip;
@property (nonatomic, assign)NSInteger price;
@end

@interface GLD_ExpressListModel : GLD_BaseModel
@property (nonatomic, strong)NSMutableArray<GLD_ExpressModel> *data;
@end
