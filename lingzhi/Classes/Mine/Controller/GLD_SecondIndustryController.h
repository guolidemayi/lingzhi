//
//  GLD_SecondIndustryController.h
//  lingzhi
//
//  Created by yiyangkeji on 2018/1/9.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseViewController.h"

typedef void(^industryBlock)(NSString *name);
@interface GLD_SecondIndustryController : GLD_BaseViewController
@property (nonatomic, copy)industryBlock nameBlock;
@property (nonatomic, copy)NSString *firstTitle;//一级标题
@end
