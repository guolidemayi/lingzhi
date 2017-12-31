//
//  GLD_RemindModel.m
//  yxvzb
//
//  Created by yiyangkeji on 17/2/8.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_RemindModel.h"

@implementation GLD_RemindModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"remindId"
                                                       }];
}
@end

@implementation GLD_RemindListModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}
@end
