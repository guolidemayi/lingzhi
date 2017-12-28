//
//  GLD_ChooseIndustryControllr.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/28.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//
#import "GLD_BaseViewController.h"

typedef void(^industryBlock)(NSString *name);
@interface GLD_ChooseIndustryControllr : GLD_BaseViewController

@property (nonatomic, copy)industryBlock nameBlock;
@end
