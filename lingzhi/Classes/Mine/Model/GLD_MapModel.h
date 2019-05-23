//
//  GLD_MapModel.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/8.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GLD_MapModel : JSONModel

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end
