//
//  HLCreatThemeView.m
//  HLFamily
//
//  Created by 胡红磊 on 2019/11/18.
//  Copyright © 2019 博学明辨. All rights reserved.
//

#import "HLCreatThemeView.h"


@interface HLCreatThemeView ()<UITextFieldDelegate>

@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *subTitleLabel;
@property (nonatomic, strong)UIButton *sureBut;
@property (nonatomic, strong)UIButton *cancleBut;
@property (nonatomic, strong)UITextField *content;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)NSString *defaultTheme;

@end

@implementation HLCreatThemeView

- (instancetype)initWithFrame:(CGRect)frame addDefaultTheme:(nonnull NSString *)defaultTheme
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [YXUniversal colorWithHexString:@"#000000" alpha:.7];
        _defaultTheme = defaultTheme;
        [self setupUI];
        [self layout];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.bottomView];
    [self.contentView addSubview:self.cancleBut];
    [self.contentView addSubview:self.sureBut];
    [self.contentView addSubview:self.content];

}
- (void)layout{
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(WIDTH(375));
        make.width.equalTo(WIDTH(300));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(W(25));
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(W(18));
        make.centerX.equalTo(self.contentView);
    }];
    
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLabel.mas_bottom).inset(W(62));
        make.left.right.equalTo(self.contentView).inset(W(52));
        make.height.equalTo(WIDTH(30));
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.content.mas_bottom).inset(W(7));
        make.left.right.equalTo(self.contentView).inset(W(52));
        make.height.equalTo(WIDTH(0.5f));
    }];
    
    [self.sureBut mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self.contentView);
         make.top.equalTo(self.bottomView.mas_bottom).offset(W(35));
        make.width.equalTo(WIDTH(210));
        make.height.equalTo(WIDTH(50));
     }];
    [self.cancleBut mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(self.contentView);
         make.top.equalTo(self.sureBut.mas_bottom).offset(W(15));
        make.width.equalTo(WIDTH(210));
        make.height.equalTo(WIDTH(45));
     }];
}

- (void)sureClick{
    
    if ([self.delegate respondsToSelector:@selector(didSelectTheme:)]) {
        [self.delegate didSelectTheme:self.content.text];
    }
    [self cancelClick];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (self.content.text.length >= 10&&IsExist_String(string)) {
        return NO;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //收回键盘
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}


- (void)cancelClick{
    [UIView animateWithDuration:.2 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIView *)contentView{
    if(!_contentView){
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10;
    }
    return _contentView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [YXUniversal colorWithHexString:@"#979797"];
    }
    return _bottomView;
}

- (UIButton *)cancleBut{
    if (!_cancleBut) {
        _cancleBut = [UIButton new];
        [_cancleBut setTitle:@"取 消" forState:UIControlStateNormal];
        _cancleBut.size = CGSizeMake(W(210), W(45));
        _cancleBut.titleLabel.font = WTFont(20);
        [_cancleBut setTitleColor:[YXUniversal colorWithHexString:@"#4C4C4C"] forState:UIControlStateNormal];
        _cancleBut.layer.borderWidth = 1.f;
        _cancleBut.layer.borderColor = [YXUniversal colorWithHexString:@"#CBCBCB"].CGColor;
        _cancleBut.layer.cornerRadius = W(45/2.0);
        _cancleBut.layer.masksToBounds= YES;
        
        [_cancleBut addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBut;
}
- (UIButton *)sureBut{
    if (!_sureBut) {
        _sureBut = [UIButton new];
        _sureBut.titleLabel.font = WTFont(20);
        
        [_sureBut setTitle:@"确 定" forState:UIControlStateNormal];
        _sureBut.size = CGSizeMake(W(210), W(50));
        [_sureBut addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
        _sureBut.width = W(210);
        _sureBut.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_RED_TEXT];
        _sureBut.layer.cornerRadius = W(25);
//        _sureBut.layer.shadowOffset = CGSizeMake(0, 5);
//        _sureBut.layer.shadowColor = [YXUniversal colorWithHexString:@"#FFDFDE"].CGColor;
//        _sureBut.layer.shadowOpacity = 1;
        
    }
    return _sureBut;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"新建分类";
        _titleLabel.font = WTFont(20);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [YXUniversal colorWithHexString:@"3F3E40"];
    }
    return _titleLabel;
}

-(UILabel *)subTitleLabel{
    
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
//        _subTitleLabel.text = @"新建主题";
        _subTitleLabel.font = WTFont(17);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.textColor = [YXUniversal colorWithHexString:@"666666"];
    }
    return _subTitleLabel;
}

- (UITextField *)content{
    
    if (!_content) {
        _content = [UITextField new];
        _content.backgroundColor = [UIColor clearColor];
        _content.font = WTFont(21);
        _content.delegate = self;
        _content.text =_defaultTheme;
        _content.textColor = [YXUniversal colorWithHexString:@"#5D5D5D"];
        _content.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"自定义主题" attributes:@{NSForegroundColorAttributeName : [YXUniversal colorWithHexString:@"#979797"]}];
        _content.attributedPlaceholder = placeholderString;
    }
    return _content;
}



@end
