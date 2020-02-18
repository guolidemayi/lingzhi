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

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_storeId forKey:@"storeId"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_summary forKey:@"summary"];
    [aCoder encodeObject:_pic forKey:@"pic"];
    [aCoder encodeObject:_userId forKey:@"userId"];
    [aCoder encodeInt64:_type forKey:@"type"];
    [aCoder encodeObject:_price forKey:@"price"];
    [aCoder encodeObject:_count forKey:@"count"];
    
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _storeId = [aDecoder decodeObjectForKey:@"storeId"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _summary = [aDecoder decodeObjectForKey:@"summary"];
        _pic = [aDecoder decodeObjectForKey:@"pic"];
        _userId = [aDecoder decodeObjectForKey:@"userId"];
        _price = [aDecoder decodeObjectForKey:@"price"];
        _type = [aDecoder decodeIntForKey:@"type"];
        _count = [aDecoder decodeObjectForKey:@"count"];
    }
    return self;
}
@end

@implementation GLD_StoreDetaiListlModel
+(BOOL)propertyIsOptional:(NSString*)propertyName;
{
    return YES;
}


@end
