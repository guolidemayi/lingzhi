//
//  GLD_DetaileBusiCell.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/4.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_DetaileBusiCell.h"
#import "GLD_ButtonLikeView.h"

NSString *const GLD_DetaileBusiCellIdentifier = @"GLD_DetaileBusiCellIdentifier";
@interface GLD_DetaileBusiCell ()

@property (nonatomic, strong)GLD_ButtonLikeView *addressView;
@property (nonatomic, strong)GLD_ButtonLikeView *phoneView;
@end
@implementation GLD_DetaileBusiCell

- (void)setupUI{
    [self.contentView addSubview:self.addressView];
    [self.contentView addSubview:self.phoneView];
    
    
}

- (void)layout{
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
    }];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(WIDTH(25));
    }];
}
- (GLD_ButtonLikeView *)addressView{
    if (!_addressView) {
        _addressView = [[GLD_ButtonLikeView alloc]initWithTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] Font:15];
    }
    return _addressView;
}
- (GLD_ButtonLikeView *)phoneView{
    if (!_phoneView) {
        _phoneView = [[GLD_ButtonLikeView alloc]initWithTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTyellow] Font:15];
    }
    return _phoneView;
}
@end
