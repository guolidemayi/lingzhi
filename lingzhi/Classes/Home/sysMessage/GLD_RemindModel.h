//
//  GLD_RemindModel.h
//  yxvzb
//
//  Created by yiyangkeji on 17/2/8.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "YXBaseModel.h"

@protocol GLD_RemindModel
@end

@interface GLD_RemindModel : JSONModel
@property (nonatomic, copy)NSString *remindId;
//@property (nonatomic, copy)NSString *historyMessageId;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)NSInteger type;//消息类型
@property (nonatomic, copy)NSString *summary;//详情
@property (nonatomic, copy)NSString *footMsg;//提示信息
@property (nonatomic, copy)NSString *time;//提示信息

@end

@interface GLD_RemindListModel : YXBaseModel
@property (nonatomic, strong) NSMutableArray<GLD_RemindModel> *data;
@end
