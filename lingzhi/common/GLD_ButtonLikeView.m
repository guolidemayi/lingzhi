//
//  GLD_ButtonLikeView.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_ButtonLikeView.h"

@interface GLD_ButtonLikeView ()

@property (nonatomic, strong)UIImageView *iconImgV;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIColor *titleColor;
@property (nonatomic, assign)NSInteger titleFont;
@end
@implementation GLD_ButtonLikeView

- (instancetype)initWithTitleColor:(UIColor *)color Font:(NSInteger)font
{
    self = [super init];
    if (self) {
        self.titleFont = font;
        self.titleColor = color;
        [self addSubview:self.iconImgV];
        [self addSubview:self.titleLabel];
    }
    return self;
}


- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}
- (void)setImgStr:(NSString *)imgStr{
    if ([imgStr hasPrefix:@"http://"]) {
        [self.iconImgV yy_setImageWithURL:[NSURL URLWithString:imgStr] placeholder:nil];
    }else{
        self.iconImgV.image = WTImage(imgStr);
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(W(15));
        make.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImgV);
        make.left.equalTo(self.iconImgV.mas_right).offset(W(5));
        make.right.equalTo(self).offset(W(-15));
    }];
}

- (UIImageView *)iconImgV{
    if (!_iconImgV) {
        _iconImgV = [UIImageView new];
        
    }
    return _iconImgV;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = WTFont(self.titleFont);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = self.titleColor;
    }
    return _titleLabel;
}
@end
