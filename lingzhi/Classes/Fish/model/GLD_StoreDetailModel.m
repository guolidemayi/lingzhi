//
//  GLD_StoreDetailModel.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/30.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_StoreDetailModel.h"

@implementation GLD_StoreDetailModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"storeId",
                                                       }];
}
@end

@implementation GLD_StoreDetaiListlModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}


@end
