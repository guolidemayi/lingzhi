//
//  GLD_BannerModel.m
//  lingzhi
//
//  Created by Jin on 2017/12/2.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BannerModel.h"

@implementation GLD_BannerModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"bannerID",
                                                       }];
}
@end

@implementation GLD_BannerLisModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}


@end
