//
//  GLD_BusnessModel.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BusnessModel.h"

@implementation GLD_BusnessModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"industryId",
                                                       @"description" : @"descriptionStr"
                                                       }];
}
@end

@implementation GLD_BusnessLisModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}


@end
