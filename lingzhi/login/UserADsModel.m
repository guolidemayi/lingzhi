//
//  UserADsModel.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/23.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "UserADsModel.h"

@implementation UserADsModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"adId",
                                                       }];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}
@end
