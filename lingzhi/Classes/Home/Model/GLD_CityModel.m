//
//  GLD_CityModel.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_CityModel.h"

@implementation GLD_CityModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"Id",
                                                       }];
}
@end



