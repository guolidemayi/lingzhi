//
//  GLDTagModel.m
//  HLFamily
//
//  Created by 博学明辨 on 2019/11/26.
//  Copyright © 2019 博学明辨. All rights reserved.
//

#import "GLDTagModel.h"

@implementation GLDTagModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id" : @"tagId",
                                                       }];
}
//- (NSString *)name{
//    if (_name) {
//        return [NSString stringWithFormat:@"# %@",_name];
//    }
//    return _name;
//}
@end
