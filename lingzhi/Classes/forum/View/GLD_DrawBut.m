//
//  GLD_DrawBut.m
//  line
//
//  Created by yiyangkeji on 2017/4/25.
//  Copyright © 2017年 yiyangkeji. All rights reserved.
//

#import "GLD_DrawBut.h"

@interface GLD_DrawBut ()
/** 渐变背景视图 */
@property (nonatomic, strong) UIView *gradientBackgroundView;
/** 渐变图层 */
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
/** 颜色数组 */
@property (nonatomic, strong) NSMutableArray *gradientLayerColors;


/** 折线图层 */
@property (nonatomic, strong) CAShapeLayer *lineChartLayer;
@end

@implementation GLD_DrawBut

- (instancetype)initWithFrame:(CGRect)frame andType:(NSInteger)type
{
    GLD_DrawBut *but = [[GLD_DrawBut alloc]initWithFrame:frame];
        
    [but drawGradientBackgroundView:type];
    [but setupLineChartLayerAppearance];
    
    return but;
}


- (void)drawGradientBackgroundView:(NSInteger)type {
    // 渐变背景视图（不包含坐标轴）
    self.gradientBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width , self.bounds.size.height)];
    self.gradientBackgroundView.userInteractionEnabled = NO;
    [self addSubview:self.gradientBackgroundView];
    /** 创建并设置渐变背景图层 */
    //初始化CAGradientlayer对象，使它的大小为渐变背景视图的大小
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.gradientBackgroundView.bounds;
    //设置渐变区域的起始和终止位置（范围为0-1），即渐变路径
    self.gradientLayer.startPoint = CGPointMake(0, 0.0);
    self.gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    //设置颜色的渐变过程
    self.gradientLayerColors = [NSMutableArray arrayWithArray:[self colorWithType:type]];
    self.gradientLayer.colors = self.gradientLayerColors;
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.gradientBackgroundView.layer addSublayer:self.gradientLayer];
}

- (NSArray *)colorWithType:(NSInteger)type{
    
    switch (type) {
        case 0:
            return @[(__bridge id)[YXUniversal colorWithHexString:@"#2EEDFF"].CGColor, (__bridge id)[YXUniversal colorWithHexString:@"#027CFA"].CGColor];
            break;
        case 1:
            return @[(__bridge id)[YXUniversal colorWithHexString:@"#EBA3FF"].CGColor, (__bridge id)[YXUniversal colorWithHexString:@"#704AFB"].CGColor];
            break;
        case 2:
            return @[(__bridge id)[YXUniversal colorWithHexString:@"#FFAAAA"].CGColor, (__bridge id)[YXUniversal colorWithHexString:@"#FF300A"].CGColor];
            break;
        case 3:
            return @[(__bridge id)[YXUniversal colorWithHexString:@"#B4ED50"].CGColor, (__bridge id)[YXUniversal colorWithHexString:@"#429321"].CGColor];
            break;
        case 4:
            return @[(__bridge id)[YXUniversal colorWithHexString:@"#4FE8FF"].CGColor, (__bridge id)[YXUniversal colorWithHexString:@"#7945FF"].CGColor];
            break;
        case 5:
            return @[(__bridge id)[YXUniversal colorWithHexString:@"#FFF592"].CGColor, (__bridge id)[YXUniversal colorWithHexString:@"#FF6D03"].CGColor];
            break;
        case 6:
            return @[(__bridge id)[YXUniversal colorWithHexString:@"#93E9FF"].CGColor, (__bridge id)[YXUniversal colorWithHexString:@"#013BFF"].CGColor];
            break;
    }
   return @[(__bridge id)[YXUniversal colorWithHexString:@"#2EEDFF"].CGColor, (__bridge id)[YXUniversal colorWithHexString:@"#027CFA"].CGColor];
}

- (void)setupLineChartLayerAppearance {
    /** 折线路径 */
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    
    for (int i = 0; i < 7; i++) {
        
        switch (i) {
            case 0:
                [path moveToPoint:CGPointMake(1, 1)];
                break;
            case 1:
                [path addLineToPoint:CGPointMake(1, self.bounds.size.height/2)];
                
                break;
            case 2:
                [path addArcWithCenter:CGPointMake(self.bounds.size.height/2 +1, self.bounds.size.height/2-1) radius:self.bounds.size.height/2 startAngle:M_PI endAngle:M_PI/2 clockwise:NO]; // 添加一条弧线
                //                [path addLineToPoint:CGPointMake(51, 101)];
                break;
            case 3:
                [path addLineToPoint:CGPointMake(self.bounds.size.width-1, self.bounds.size.height-1)];
                break;
            case 4:
                [path addLineToPoint:CGPointMake(self.bounds.size.width-1, self.bounds.size.height-1)];
                break;
            case 5:
                [path addArcWithCenter:CGPointMake((self.bounds.size.width - self.bounds.size.height/2-1), self.bounds.size.height/2+1) radius:self.bounds.size.height/2 startAngle:0 endAngle:M_PI*3/2 clockwise:NO];
                //                [path addLineToPoint:CGPointMake(151, 1)];
                break;
            case 6:
                [path addLineToPoint:CGPointMake(1, 1)];
                break;
            default:
                break;
        }
    }
    
    /** 将折线添加到折线图层上，并设置相关的属性 */
    self.lineChartLayer = [CAShapeLayer layer];
    self.lineChartLayer.path = path.CGPath;
    self.lineChartLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.lineChartLayer.fillColor = [[UIColor clearColor] CGColor];
    // 默认设置路径宽度为0，使其在起始状态下不显示
    self.lineChartLayer.lineWidth = 0;
//    self.lineChartLayer.lineCap = kCALineCapRound;
//    self.lineChartLayer.lineJoin = kCALineJoinRound;
    // 设置折线图层为渐变图层的mask
    self.gradientBackgroundView.layer.mask = self.lineChartLayer;
}

/** 动画开始，绘制折线图 */
- (void)startDrawlineChart {
    // 设置路径宽度为4，使其能够显示出来
    self.lineChartLayer.lineWidth = 1;
    
    // 设置动画的相关属性
//    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    pathAnimation.duration = 0.1;
//    pathAnimation.repeatCount = 1;
//    pathAnimation.removedOnCompletion = YES;
//    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
//    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
//    // 设置动画代理，动画结束时添加一个标签，显示折线终点的信息
//    
//    [self.lineChartLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

@end
