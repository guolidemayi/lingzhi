//
//  GLD_DrawBut.h
//  line
//
//  Created by yiyangkeji on 2017/4/25.
//  Copyright © 2017年 yiyangkeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLD_TopicModel;
@interface GLD_DrawBut : UIButton

@property (nonatomic, strong)GLD_TopicModel *model;
@property (nonatomic, assign)NSInteger type;//渲染颜色

- (instancetype)initWithFrame:(CGRect)frame andType:(NSInteger)type;
- (void)startDrawlineChart;//方便扩展。 （增加动画效果什么的）
@end
