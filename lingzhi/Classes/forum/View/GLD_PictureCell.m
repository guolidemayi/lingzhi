//
//  GLD_PictureCell.m
//  yxvzb
//
//  Created by yiyangkeji on 2017/4/27.
//  Copyright © 2017年 sendiyang. All rights reserved.
//

#import "GLD_PictureCell.h"

@interface GLD_PictureCell ()






@end

@implementation GLD_PictureCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self layout];
        
    }
    return self;
}


- (void)butClick{
    if ([self.delegate respondsToSelector:@selector(deletePicture:)]) {
        [self.delegate deletePicture:self.tag];
    }
}
- (void)setupUI{
    
    UIImageView *imgV = [[UIImageView alloc]initWithImage:WTImage(@"添加 copy 2")];
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.layer.masksToBounds = YES;
    self.picImageV = imgV;
    [self.contentView addSubview:imgV];
    
    UIButton *but = [[UIButton alloc]init];
    [self.contentView addSubview:but];
    [but addTarget:self action:@selector(butClick) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBut = but;
    [but setBackgroundImage:WTImage(@"删除图片") forState:UIControlStateNormal];
    
}

- (void)layout{
    [self.picImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.height.equalTo(WIDTH(95));
    }];
    [self.deleteBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.picImageV.mas_right).offset(W(-5));
        make.centerY.equalTo(self.picImageV.mas_top);
        make.height.width.equalTo(WIDTH(18));
    }];
    
}
@end
