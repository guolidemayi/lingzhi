//
//  GLD_Button.m
//  yxvzb
//
//  Created by yiyangkeji on 17/1/19.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_Button.h"

@implementation GLD_Button

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, CGRectGetMinY(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.titleLabel.frame));
    self.imageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+5, 0, CGRectGetWidth(self.imageView.frame), CGRectGetHeight(self.imageView.frame));

}

@end
