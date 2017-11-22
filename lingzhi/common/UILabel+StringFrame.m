//
//  UILabel+StringFrame.m
//  p2p
//
//  Created by wangxin on 15/3/12.
//  Copyright (c) 2015年 sendiyang. All rights reserved.
//

#import "UILabel+StringFrame.h"

@implementation UILabel (StringFrame)
- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}

+(UILabel *)creatLableWithText:(NSString *)text andFont:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment  textColor:(UIColor *)textColor
{
    //时间
   UILabel *lable = [[UILabel alloc]initWithFrame:CGRectZero];
    
    lable.text = text;
    
    lable.font = font;
    
    lable.textAlignment = textAlignment;
    
    lable.textColor = textColor;
//    [lable sizeToFit];
    
    return lable;
    
}

@end
