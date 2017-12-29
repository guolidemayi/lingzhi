//
//  YXBaseModel.h
//  yxvzb
//
//  Created by wangxin on 16/4/18.
//  Copyright © 2016年 sendiyang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YXBaseModel : JSONModel

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *st;

@property (nonatomic, copy) NSString *et;


@end
