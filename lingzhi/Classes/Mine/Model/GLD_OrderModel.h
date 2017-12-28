//
//  GLD_OrderModel.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/28.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@protocol GLD_OrderModel

@end
@interface GLD_OrderModel : JSONModel
@property (nonatomic, copy)NSString *busnessId;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end


@interface GLD_OrderModelListModel : JSONModel

@property (nonatomic, strong) NSMutableArray<GLD_OrderModel> *shoporder;
@end
