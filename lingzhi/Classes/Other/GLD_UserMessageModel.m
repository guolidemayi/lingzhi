//
//  GLD_UserMessageModel.m
//  lingzhi
//
//  Created by rabbit on 2017/12/28.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_UserMessageModel.h"

@implementation GLD_UserMessageModel

+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"userId",
                                                       }];
}
@end
@implementation GLD_UserModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}
@end
