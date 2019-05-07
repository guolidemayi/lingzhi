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
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *start;
@property (nonatomic, copy)NSString *expressId;
@property (nonatomic, copy)NSString *end;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, assign)NSInteger price;
@property (nonatomic, assign)NSInteger state;//0 可抢单 1 派件中 2 完成
//纬度（竖直方向）
@property (nonatomic, assign) CGFloat latitude;
///经度（水平方向）
@property (nonatomic, assign) CGFloat longitude;
@end

@interface GLD_ExpressListModel : GLD_BaseModel
@property (nonatomic, strong)NSMutableArray<GLD_ExpressModel> *data;
@end
