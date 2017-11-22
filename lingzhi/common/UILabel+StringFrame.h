//
//  UILabel+StringFrame.h
//  p2p
//
//  Created by wangxin on 15/3/12.
//  Copyright (c) 2015年 sendiyang. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface UILabel (StringFrame)

- (CGSize)boundingRectWithSize:(CGSize)size;
+(UILabel *)creatLableWithText:(NSString *)text andFont:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment  textColor:(UIColor *)textColor;
@end
