//
//  CollectionViewHeaderView.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "CollectionViewHeaderView.h"

@implementation CollectionViewHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
//        self.backgroundColor = rgba(240, 240, 240, 0.8);
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.title.font = [UIFont systemFontOfSize:14];
        self.title.textColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKblack];
        self.title.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.title];
        self.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTGrayTable];
        [self layout];
    }
    return self;
}
- (void)layout{
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(self);
        make.left.equalTo(self).offset(15);
    }];
}
@end
