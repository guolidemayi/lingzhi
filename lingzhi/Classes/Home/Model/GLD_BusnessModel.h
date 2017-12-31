//
//  GLD_BusnessModel.h
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BaseModel.h"

@protocol GLD_BusnessModel

@end
@interface GLD_BusnessModel : JSONModel
@property (nonatomic, copy)NSString *logo;//图片
@property (nonatomic, copy) NSString *name;//标题
@property (nonatomic, copy)NSString *industryId;//id
@property (nonatomic, copy) NSString *desc;//描述
@property (nonatomic, copy) NSString *cellphone;
@property (nonatomic, copy) NSString *address;//地址
@property (nonatomic, copy) NSString *xpoint;//纬度
@property (nonatomic, copy) NSString *ypoint;//经度
@property (nonatomic, copy) NSString *distance;//距离
@property (nonatomic, copy) NSString *evaluateScore;//等级
@property (nonatomic, copy) NSString *isCollect;//收藏
@property (nonatomic, copy) NSString *isOpenRebate;//
@property (nonatomic, copy) NSString *category;//所属行业
@property (nonatomic, copy)NSString *busnessType; //1高级  2普通

@end
@interface GLD_BusnessLisModel : GLD_BaseModel
@property (nonatomic, strong) NSMutableArray<GLD_BusnessModel> *data;
@end
