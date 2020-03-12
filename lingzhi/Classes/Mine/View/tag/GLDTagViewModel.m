//
//  GLDTagViewModel.m
//  HLFamily
//
//  Created by 博学明辨 on 2019/11/26.
//  Copyright © 2019 博学明辨. All rights reserved.
//

#import "GLDTagViewModel.h"
#import "GLDTagModel.h"


@interface GLDTagViewModel ()

@property (nonatomic, strong) GLDTagModel *rawValue;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *tagId;
@property (nonatomic, assign) CGFloat itemWidth;
@end
@implementation GLDTagViewModel

- (instancetype)initWithObject:(id)object{
    if (self = [super init]) {
        self.rawValue = object;
    }
    return self;
}
- (void)setRawValue:(GLDTagModel *)rawValue{
    _rawValue = rawValue;
    
    self.nameStr = rawValue.name;
    self.tagId = rawValue.tagId;
    self.itemWidth = W([YXUniversal calculateLabelWidth:21 text:rawValue.name font:WTFont(15)] + 15);
}
@end
