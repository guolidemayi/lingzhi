//
//  YXLiveingHotModel.m
//  yxvzb
//
//  Created by yiyangkeji on 16/9/18.
//  Copyright © 2016年 sendiyang. All rights reserved.
//

#import "YXLiveingHotModel.h"

@implementation YXCommentContent2Model

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"commentId",
                                                       @"userPhoto" : @"replyUserHeadPhoto",
                                                       @"content" : @"replyContent",
                                                       @"userId" : @"replyUserId",
                                                       @"userName" : @"replyUserNickName",
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}
@end

@implementation YXCommentContent1Model
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}
@end
@implementation YXCommentListModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}
@end
