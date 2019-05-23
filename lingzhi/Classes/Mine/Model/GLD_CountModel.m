//
//  GLD_CountModel.m
//  lingzhi
//
//  Created by yiyangkeji on 2018/2/9.
//  Copyright © 2018年 com.lingzhi. All rights reserved.
//

#import "GLD_CountModel.h"

@implementation GLD_CountModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"countId",
                                                       }];
}
@end
@implementation GLD_CountDataModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}


@end
