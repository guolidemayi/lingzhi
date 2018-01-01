//
//  GLD_ChangePhoneController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/12.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_ChangePhoneController.h"
#import "GLD_GetVerificationController.h"

@interface GLD_ChangePhoneController ()

@property (nonatomic, strong)UILabel *titleLabel;//标题
@property (nonatomic, strong)UIButton *applyBut;//现金
@end

@implementation GLD_ChangePhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.applyBut];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layout];
}

- (void)layout{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(W(30));
    }];
    [self.applyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(W(30));
        make.width.equalTo(WIDTH(345));
        make.height.equalTo(WIDTH(44));
    }];
}
- (void)applybutClick{
    GLD_GetVerificationController *verifica = [GLD_GetVerificationController new];
    [self.navigationController pushViewController:verifica animated:YES];
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = WTFont(15);
        
        NSString *str = [AppDelegate shareDelegate].userModel.phone;
        NSRange rang ;
        rang.location = 3;
        rang.length = 4;
        if (str.length == 11)
        str = [str stringByReplacingCharactersInRange:rang withString:@"****"];
        _titleLabel.text = [NSString stringWithFormat:@"手机绑定 ：%@",str];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_LIGHT_BLUE];
    }
    return _titleLabel;
}
- (UIButton *)applyBut{
    if (!_applyBut) {
        _applyBut = [[UIButton alloc]init];
        [_applyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKyellow] forState:UIControlStateNormal];
        [_applyBut setTitle:@"更换绑定" forState:UIControlStateNormal];
        _applyBut.titleLabel.font = WTFont(15);
        _applyBut.layer.cornerRadius = 3;
        _applyBut.layer.masksToBounds = YES;
        _applyBut.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow].CGColor;
        _applyBut.layer.borderWidth = 1;
        [_applyBut addTarget:self action:@selector(applybutClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBut;
}
@end
