//
//  UserADsModel.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/23.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseModel.h"

@interface UserADsModel : JSONModel
@property (copy,nonatomic)NSString *adId;
//@property (copy,nonatomic)NSString *title;
@property (copy,nonatomic)NSNumber *start;//开始使用时间
@property (copy,nonatomic)NSNumber *end;
//@property (copy,nonatomic)NSString *createBy;
//@property (copy,nonatomic)NSNumber *createTime;//
@property (assign,nonatomic)NSInteger waitingTime;//过场时间（秒）
//@property (copy,nonatomic)NSString *shareImg;//分享图片
//@property (copy,nonatomic)NSString *shareTitle;//
//@property (copy,nonatomic)NSString *shareDescription;//分享描述
//@property (copy,nonatomic)NSString *shareUrl;//分享链接
//@property (copy,nonatomic)NSString *redirectUrl;//跳转
//@property (copy,nonatomic)NSString *redirectType;//跳转类型
@property (copy,nonatomic)NSString *pic; //开机图
//@property (copy,nonatomic)NSString *dataId;
@end
