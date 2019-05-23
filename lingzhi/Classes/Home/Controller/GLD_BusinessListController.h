//
//  GLD_BusinessListController.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseViewController.h"

@class GLD_IndustryModel;
@interface GLD_BusinessListController : GLD_BaseViewController

@property (nonatomic, copy)NSString *cityName;//定位城市
@property (nonatomic, strong)GLD_IndustryModel *model;//类型
@end
