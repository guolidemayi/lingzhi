//
//  GLD_OrderModel.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/28.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseModel.h"


@protocol GLD_OrderModel

@end
@interface GLD_OrderModel : JSONModel
@property (nonatomic, copy)NSString *busnessId;
@property (nonatomic, copy)NSString *shopName;
@property (nonatomic, assign)CGFloat prize;//报价格
@property (nonatomic, assign)CGFloat wxPay;//实际支付
@property (nonatomic, assign)CGFloat discount;//折扣金额
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy)NSString *shopPic;//商店图标
@property (nonatomic, copy)NSString *createTime;//创建时间
@property (nonatomic, copy)NSString *orderNumber;//订单号
@property (nonatomic, copy)NSString *phone;//支付人
@property (nonatomic, copy)NSString *code;//支付人电话
@property (nonatomic, copy)NSString *address;//配送地址
@end


@interface GLD_OrderModelListModel : GLD_BaseModel

@property (nonatomic, strong) NSMutableArray<GLD_OrderModel> *data;
@end
