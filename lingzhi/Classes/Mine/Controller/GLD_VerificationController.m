//
//  GLD_VerificationController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/11.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_VerificationController.h"
#import "GLD_PhoneVerificatController.h"

@interface GLD_VerificationController ()

@property (nonatomic, strong)UIImageView *iconImgV;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *tipLabel;
@property (nonatomic, strong)UIButton *applyBut;
@property (nonatomic, strong)UIView *bgView;//

@end

@implementation GLD_VerificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}


- (void)setupUI{
    [self.view addSubview:self.bgView];
    [_bgView addSubview:self.titleLabel];
    [_bgView addSubview:self.iconImgV];
    [_bgView addSubview:self.tipLabel];
    
    [self.view addSubview:self.applyBut];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(W(15));
        make.width.equalTo(WIDTH(345));
        make.height.equalTo(WIDTH(200));
    }];
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.bgView).offset(W(15));
        make.height.width.equalTo(WIDTH(50));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.iconImgV.mas_bottom).offset(W(15));
        
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.right.bottom.equalTo(self.bgView).offset(W(-15));
        make.left.equalTo(self.bgView).offset(W(15));
        
    }];
    
    [self.applyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.bgView.mas_bottom).offset(W(15));
        make.width.equalTo(WIDTH(300));
        make.height.equalTo(WIDTH(44));
    }];
    
}
- (void)applybutClick{
    GLD_PhoneVerificatController *phoneVc = [GLD_PhoneVerificatController new];
    [self.navigationController pushViewController:phoneVc animated:YES];
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _bgView.layer.borderWidth = 1;
        
    }
    return _bgView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = WTFont(15);
        _titleLabel.text = IsExist_String([AppDelegate shareDelegate].userModel.Very) ? [AppDelegate shareDelegate].userModel.Very : @"尚未认证" ;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTBLACK];
    }
    return _titleLabel;
}
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = WTFont(12);
        _tipLabel.numberOfLines = 2;
        _tipLabel.text = IsExist_String([AppDelegate shareDelegate].userModel.VeryMsg) ?[AppDelegate shareDelegate].userModel.VeryMsg : @"实名认证";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray];
    }
    return _tipLabel;
}
- (UIButton *)applyBut{
    if (!_applyBut) {
        _applyBut = [[UIButton alloc]init];
        [_applyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKyellow] forState:UIControlStateNormal];
        [_applyBut setTitle:@"手机认证" forState:UIControlStateNormal];
        _applyBut.titleLabel.font = WTFont(15);
        _applyBut.layer.cornerRadius = 3;
        _applyBut.layer.masksToBounds = YES;
        _applyBut.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow].CGColor;
        _applyBut.layer.borderWidth = 1;
        [_applyBut addTarget:self action:@selector(applybutClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBut;
}
- (UIImageView *)iconImgV{
    if (!_iconImgV) {
        _iconImgV = [UIImageView new];
        _iconImgV.image = WTImage(@"identificationFailed");
        _iconImgV.image = IsExist_String([AppDelegate shareDelegate].userModel.Very) ? WTImage(@"identificationFailed") : WTImage(@"通过认证");
        
    }
    return _iconImgV;
}
@end
