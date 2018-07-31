//
//  GLD_ExpressModel.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/7/31.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_ExpressModel.h"

@implementation GLD_ExpressModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"expressId",
                                                       }];
}
@end
@implementation GLD_ExpressListModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}


@end
