//
//  YXLiveingHotModel.h
//  yxvzb
//
//  Created by yiyangkeji on 16/9/18.
//  Copyright © 2016年 sendiyang. All rights reserved.
//

#import "YXBaseModel.h"


@protocol YXCommentContent2Model

@end
@interface YXCommentContent2Model : JSONModel
@property (assign,nonatomic)NSInteger approval;
@property (copy,nonatomic)NSString *beReplyContent; //回复内容
@property (assign,nonatomic)NSInteger beReplyDelFlag;  //被回复的内容是否已删除 1 已删除 0 没有删除
@property (assign,nonatomic)NSInteger delFlag;  //回复的内容是否已删除 1 已删除 0 没有删除
@property (copy,nonatomic)NSString *beReplyMediaId;  //语音
@property (copy,nonatomic)NSString *beReplyVoiceTime;//语音时间
@property (copy,nonatomic)NSString *beReplyId;
@property (copy,nonatomic)NSString *beReplyUserId;
@property (copy,nonatomic)NSString *beReplyUserNickName;
@property (copy,nonatomic)NSString *createTimeString;
@property (assign,nonatomic)NSInteger fid;
@property (copy,nonatomic)NSString *commentId;
@property (copy,nonatomic)NSString *questionId;
@property (copy,nonatomic)NSString *replyContent;
@property (copy,nonatomic)NSString *replyUserHeadPhoto;
@property (copy,nonatomic)NSString *replyUserId;
@property (copy,nonatomic)NSString *replyUserNickName;
@property (copy,nonatomic)NSString *replyMediaId;
@property (copy,nonatomic)NSString *replyVoiceTime;
@property (assign,nonatomic)NSInteger likeCount; //点赞数
@property (assign,nonatomic)NSInteger type;
@property (assign,nonatomic)BOOL like;
@property (copy,nonatomic)NSString *courseId;
@property (nonatomic,assign)CGFloat replyHieght;
@property (nonatomic,assign)CGFloat beReplyHieght;
@property (copy,nonatomic)NSString *ext2;
@property (assign,nonatomic)BOOL replyIsAuth;//是否认证
@property (copy,nonatomic)NSString *pic;
@property (copy,nonatomic)NSString *themeName;
@property (copy,nonatomic)NSString *isQaQuestionDelFlag;//是否删除帖子 @“1” 删除

@end

@interface YXCommentContent1Model : JSONModel
@property (nonatomic, strong)NSMutableArray<YXCommentContent2Model> *list;

@property (assign,nonatomic)NSInteger commentCount;
@property (assign,nonatomic)BOOL hasMore;
@end


@interface YXCommentListModel : YXBaseModel
@property (nonatomic, strong)YXCommentContent1Model *data;
@end
