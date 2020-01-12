//
//  UIImage+Extension.h
//  HLFamily
//
//  Created by 博学明辨 on 2019/9/27.
//  Copyright © 2019 王卫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)


/**
 处理圆角后图片

 @param radius 圆角
 @return 处理圆角后图片
 */
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius;


/**
 处理圆角后图片

 @param radius 圆角
 @param corners 需要切的角
 @param borderWidth 边缘宽度
 @param borderColor 边缘颜色
 @param borderLineJoin 交叉方式
 @return 处理圆角后图片
 */
- (nullable UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                                       corners:(UIRectCorner)corners
                                   borderWidth:(CGFloat)borderWidth
                                   borderColor:(nullable UIColor *)borderColor
                                borderLineJoin:(CGLineJoin)borderLineJoin;



/// 图片
/// @param color 颜色
+ (UIImage *)imageWithColor:(UIColor *)color;

/// 毛玻璃效果
- (UIImage *)imageByBlurDark;
@end

NS_ASSUME_NONNULL_END
