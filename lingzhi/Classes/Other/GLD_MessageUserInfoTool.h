//
//  GLD_MessageUserInfoTool.h
//  yxvzb
//
//  Created by yiyangkeji on 2018/8/13.
//  Copyright © 2018年 sendiyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLD_StoreDetailModel.h"

@interface GLD_MessageUserInfoTool : NSObject

+ (NSArray *)readDiskAllCache;
+ (void)removeAdsList:(GLD_StoreDetailModel *)model;
+ (void)writeDiskCache:(GLD_StoreDetailModel *)model;

@end
