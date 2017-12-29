//
//  GLD_ForumDetailModel.h
//  yxvzb
//
//  Created by yiyangkeji on 2017/5/2.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "YXBaseModel.h"
#import "GLD_TopicModel.h"


@interface GLD_ForumNewsDetailModel : YXBaseModel

@property (nonatomic, copy)NSString *contentWebUrl;
@property (nonatomic, copy)NSString *newsId;
@property (nonatomic, copy)NSString *sharePic;
@property (nonatomic, copy)NSString *shareTitle;
@property (nonatomic, copy)NSString *shareUrl;
@property (nonatomic, copy)NSString *shareDesc;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, strong)NSMutableArray<GLD_TopicModel> *topicList;
@property (nonatomic, assign)NSInteger type;    //2病例。4 帖子。 8。课程答疑
@property (nonatomic, assign)BOOL collected;
@property (nonatomic, assign)NSInteger collectionCount;
@end


@interface GLD_ForumDataModel : YXBaseModel

@property (nonatomic, strong)GLD_ForumNewsDetailModel *data;

@end
