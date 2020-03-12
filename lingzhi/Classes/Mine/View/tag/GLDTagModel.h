//
//  GLDTagModel.h
//  HLFamily
//
//  Created by 博学明辨 on 2019/11/26.
//  Copyright © 2019 博学明辨. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLDTagModel : JSONModel

@property (nonatomic, copy) NSString *tagId;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSNumber *status;


@end

NS_ASSUME_NONNULL_END
