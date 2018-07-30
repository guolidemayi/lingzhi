//
//  GLD_CustomBut.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/11/24.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_CustomBut.h"

@interface GLD_CustomBut ()
@property (nonatomic, strong)UILabel *locationLabel;
@property (nonatomic, strong)UIImageView *imgV;
@property (nonatomic, strong)UIView *redPoint;
@end
@implementation GLD_CustomBut

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.locationLabel];
        [self addSubview:self.imgV];
        [self.imgV addSubview:self.redPoint];
        [self layout];
    }
    return self;
}

- (void)showRedPoint{
    self.redPoint.hidden = NO;
}
- (void)hiddenRedPoint{
    self.redPoint.hidden = YES;
}

- (void)title:(NSString *)title{
    self.locationLabel.text = title;
}
- (void)image:(NSString *)image{
    self.imgV.image = WTImage(image);
}

- (void)layout{
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationLabel.mas_right).offset(5);
        make.centerY.equalTo(self);
//        make.width.height.equalTo(@(15));
    }];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(5);
    }];
    [self.redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imgV.mas_right);
        make.centerY.equalTo(self.imgV.mas_top);
        make.width.height.equalTo(@(8));
    }];
}

- (UILabel *)locationLabel{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc]init];
        _locationLabel.font = WTFont(15);
        _locationLabel.textColor = [UIColor whiteColor];
//        _locationLabel.textColor = [UIColor blackColor];
        
    }
    return _locationLabel;
}
- (UIView *)redPoint{
    if (!_redPoint) {
        _redPoint = [UIView new];
        _redPoint.layer.cornerRadius = 4;
        _redPoint.layer.masksToBounds = YES;
        _redPoint.hidden = YES;
        _redPoint.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTRED];
    }
    return _redPoint;
}
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        
    }
    return _imgV;
}

@end
