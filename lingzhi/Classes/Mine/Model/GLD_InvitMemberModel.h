//
//  GLD_InvitMemberModel.h
//  lingzhi
//
//  Created by yiyangkeji on 2018/8/1.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseModel.h"

@protocol GLD_InvitMemberModel
@end
@interface GLD_InvitMemberModel : GLD_BaseModel

@property (nonatomic, copy)NSString *imgStr;//图片
@property (nonatomic, copy)NSString *point;//分数
@property (nonatomic, copy)NSString *pic;//图片
@property (nonatomic, copy)NSString *title;//图片
@end

@interface GLD_InvitMemberListModel : GLD_BaseModel

@property (nonatomic, strong)NSMutableArray<GLD_InvitMemberModel> *data;
@end
