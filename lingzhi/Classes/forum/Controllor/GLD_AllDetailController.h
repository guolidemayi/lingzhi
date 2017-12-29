//
//  GLD_AllDetailController.h
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/25.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_BaseViewController.h"

@class GLD_TopicModel;
@interface GLD_AllDetailController : GLD_BaseViewController

@property (nonatomic, strong)GLD_TopicModel *keywordModel;
@property (nonatomic, assign)NSInteger topImgType;
@property (nonatomic, assign) BOOL isCorrelation;

@end
