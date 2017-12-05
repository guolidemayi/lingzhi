//
//  GLD_IndustryModel.m
//  lingzhi
//
//  Created by Jin on 2017/12/2.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_IndustryModel.h"

@implementation GLD_IndustryModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"industryId",
                                                       }];
}
@end

@implementation GLD_IndustryListModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}


@end
