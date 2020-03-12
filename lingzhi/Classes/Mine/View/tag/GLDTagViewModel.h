//
//  GLDTagViewModel.h
//  HLFamily
//
//  Created by 博学明辨 on 2019/11/26.
//  Copyright © 2019 博学明辨. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface GLDTagViewModel : NSObject
- (instancetype)initWithObject:(id)object;
- (NSString *)tagId;
- (NSString *)nameStr;
- (CGFloat)itemWidth;
@end

NS_ASSUME_NONNULL_END
