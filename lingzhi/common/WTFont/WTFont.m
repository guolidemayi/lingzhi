//
//  WTFont.m
//  MingTieApp
//
//  Created by felix liang on 10/23/15.
//  Copyright © 2015 SDY. All rights reserved.
//

#import "WTFont.h"

@implementation UIFont (AdaptFont)


+ (UIFont *)systemFontOfAdaptSize:(CGFloat)fontSize
{
    
    UIFont *font;
    if (iPhone6Plus) {
        font = [UIFont systemFontOfSize:fontSize*1.1];
    }else if (iPhone6){
        font = [UIFont systemFontOfSize:fontSize];
    }else if (iPhone5){
        font = [UIFont systemFontOfSize:fontSize*0.9];
    }else if (iPhone4){
        font = [UIFont systemFontOfSize:fontSize*0.9];
    }else{
        font = [UIFont systemFontOfSize:fontSize];
    }
    
    return font;
}

+ (UIFont *)boldsystemFontOfAdaptSize:(CGFloat)fontSize
{
    UIFont *font;
    if (iPhone6Plus) {
        font = [UIFont boldSystemFontOfSize:fontSize*1.1];
    }else if (iPhone6){
        font = [UIFont boldSystemFontOfSize:fontSize];
    }else if (iPhone5){
        font = [UIFont boldSystemFontOfSize:fontSize*0.8];
    }else if (iPhone4){
        font = [UIFont boldSystemFontOfSize:fontSize*0.8];
    }else{
        font = [UIFont boldSystemFontOfSize:fontSize];
    }
    
    return font;
}

@end
