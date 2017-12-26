//
//  GLD_WirteIntroController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/6.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_WirteIntroController.h"
#import "KeyboardManager.h"
#import "TestViewController.h"

@interface GLD_WirteIntroController ()<UITextViewDelegate>

@property (nonatomic, strong)IQTextView *textView;
@property (nonatomic, strong)UIButton *commitBut;
@end

@implementation GLD_WirteIntroController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑个人简介";
    self.view.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_BLUE_TABLE];
    // Do any additional setup after loading the view.
//    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self.view addSubview:self.textView];
    self.commitBut = ({
        UIButton * button = [UIButton new];
        [button setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow];
        [button setTitle:@"提交" forState:UIControlStateNormal];
        button.titleLabel.font = WTFont(15);
        [button addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKwirte] forState:UIControlStateNormal];
        button;
    });
    
    [self.view addSubview:self.commitBut];
    [_commitBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(W(15));
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.textView);
        make.height.equalTo(WIDTH(44));
    }];
}
- (void)commitClick{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"TestViewController")]) {
            TestViewController *v = (TestViewController *)vc;
            v.dec = self.textView.text;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (UITextView *)textView{
    if (!_textView) {
        
        _textView = [[IQTextView alloc]init];
        _textView.frame = CGRectMake(W(15), W(15), DEVICE_WIDTH - W(30), W(100));
        _textView.delegate = self;
        _textView.placeholder = @"请编辑您的个人简介";
    }
    return _textView;
}


@end
