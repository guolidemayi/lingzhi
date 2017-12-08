//
//  GLD_WirteIntroController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/6.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_WirteIntroController.h"
#import "KeyboardManager.h"

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
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [self.view addSubview:self.textView];
    self.commitBut = ({
        UIButton * button = [UIButton new];
        [button setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow];
        [button setTitle:@"安逸酒店" forState:UIControlStateNormal];
        button.titleLabel.font = WTFont(15);
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    NSLog(@"内容长度 = %zd , text= %@",textView.text.length, text);
//    NSUInteger proposedNewLength = textView.text.length - range.length + text.length;
//    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
//        //在这里做你响应return键的代码
//        NSString *temp = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//        if (temp.length != 0) {
//            [self.textView resignFirstResponder];
//            self.backView.frame =  CGRectMake(0, DEVICE_HEIGHT - 44, DEVICE_WIDTH, 44);
//            if ([self.delegate respondsToSelector:@selector(sendKeyboard:)]) {
//                [self.delegate sendKeyboard:self.textField.text];
//                self.textField.text = @"";
//            }
//        }else{
//            [CAToast showWithText:@"请输入内容"];
//            return NO;
//        }
//        return YES; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
//    }
    return YES;
}

- (UITextView *)textView{
    if (!_textView) {
        NSTextContainer *container = [[NSTextContainer alloc]initWithSize:CGSizeMake((DEVICE_WIDTH - W(35)), W(90))];
        _textView = [[IQTextView alloc]initWithFrame:CGRectMake(W(15), W(15), DEVICE_WIDTH - W(30), W(100)) textContainer:container];
        _textView.delegate = self;
        _textView.placeholder = @"请编辑您的个人简介";
    }
    return _textView;
}


@end
