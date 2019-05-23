//
//  GLD_ExpressViewModelProtocol.h
//  lingzhi
//
//  Created by 锅里的 on 2019/5/15.
//  Copyright © 2019 com.lingzhi. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class GLD_ExpressModel;
@protocol GLD_ExpressViewModelProtocol <NSObject>

- (instancetype)initWithModel:(GLD_ExpressModel *)model;
- (NSString *)sendPersonStr;
- (NSString *)sendPhoneStr;
- (NSString *)receivedPersonStr;
- (NSString *)receivedPhoneStr;
- (NSURL *)goodsPic;
- (NSString *)price;
- (GLD_ExpressModel *)expressModel;
- (CGFloat)cellHeight;
- (CGFloat)contentHeight;

@end
