//
//  GLD_ForumModel.h
//  yxvzb
//
//  Created by yiyangkeji on 2017/5/2.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "YXBaseModel.h"

@protocol GLD_ForumDetailModel

@end
@interface GLD_ForumDetailModel : YXBaseModel


@property (nonatomic, copy)NSString *dutie;//职称
@property (nonatomic, copy)NSString *companyName;
@property (nonatomic, copy)NSString *headIco;//
@property (nonatomic, copy)NSString *imageUrl;
@property (nonatomic, copy)NSString *newsId;
@property (nonatomic, copy)NSString *nickName;
@property (nonatomic, copy)NSString *userName;
@property (nonatomic, copy)NSString *summary;//内容简介
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *type;  //病例 2。   课程答疑 4。    用户帖子8

@property (nonatomic, assign)NSInteger collectionCount;
@property (nonatomic, assign)NSInteger commentCount;
@property (nonatomic, assign)NSInteger readCount;
@property (nonatomic, copy)NSString *collectionId;//收藏id
@property (nonatomic, assign)BOOL isDel; //0 未删除。1 已删除

@end
@interface GLD_ForumModel : YXBaseModel

@property (nonatomic, strong) NSMutableArray<GLD_ForumDetailModel> *list;
@property (nonatomic, assign)BOOL hasMore;
@property (nonatomic, assign)NSInteger totalNum;
@end

@interface GLD_ForumSearchModel : YXBaseModel
@property (nonatomic, strong) NSMutableArray<GLD_ForumDetailModel> *binglis;
@property (nonatomic, strong) NSMutableArray<GLD_ForumDetailModel> *questions;
@end
