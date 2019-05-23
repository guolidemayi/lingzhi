//
//  GLD_ExpressAdressController.h
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/31.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseViewController.h"

@class AMapPOI;
@interface GLD_ExpressAdressController : GLD_BaseViewController

+ (instancetype)initWithBlock:(void (^)(AMapPOI *location))block;
@end
