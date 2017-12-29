//
//  GLD_TopicModel.h
//  yxvzb
//
//  Created by yiyangkeji on 2017/5/2.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "YXBaseModel.h"

@protocol GLD_TopicModel

@end

@interface GLD_TopicModel : YXBaseModel

@property (nonatomic, copy)NSString *categoryId;
@property (nonatomic, copy)NSString *categoryName;
@end


@interface GLD_TopicDataModel : YXBaseModel

@property (nonatomic, strong)NSMutableArray<GLD_TopicModel> *data;

@end
