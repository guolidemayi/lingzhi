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
@end
@implementation GLD_CustomBut

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.locationLabel];
        [self addSubview:self.imgV];
        [self layout];
    }
    return self;
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
}

- (UILabel *)locationLabel{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc]init];
        _locationLabel.font = WTFont(15);
        _locationLabel.textColor = [UIColor blackColor];
        
    }
    return _locationLabel;
}

- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        
    }
    return _imgV;
}

@end
