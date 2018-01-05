//
//  InputKeyboardView.m
//  yxvzb
//
//  Created by wangxin on 16/4/29.
//  Copyright © 2016年 sendiyang. All rights reserved.
//

#import "InputKeyboardView.h"

@interface InputKeyboardView (){
    NSString *_contentText;
}
@property (nonatomic, strong)UILabel *placeHolderLabel;
@property (nonatomic, assign)BOOL first;//第一次
@end
@implementation InputKeyboardView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIView *viewBack = [[UIView alloc] initWithFrame:frame];
        viewBack.backgroundColor = [UIColor blackColor];
        viewBack.alpha = 0.6f;
        [self addSubview:viewBack];
        self.first = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboradView)];
        [self addGestureRecognizer:tap];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        self.backView = [[UIView alloc] initWithFrame: CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, 100 * DEVICEHEIGHT_SCALE)];
        self.backView.backgroundColor = [UIColor whiteColor];
        self.textField = [[UITextView alloc] initWithFrame:CGRectMake(15*DEVICEWIDTH_SCALE, 15*DEVICEHEIGHT_SCALE ,DEVICE_WIDTH -  100*DEVICEWIDTH_SCALE, 80*DEVICEHEIGHT_SCALE)];
        self.textField.delegate = self;
//        self.textField.showsVerticalScrollIndicator = NO;
        self.textField.layer.borderWidth = 1.0;//边宽
        self.textField.layer.cornerRadius = 5.0;//设置圆角
        self.textField.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray].CGColor;
        self.textField.font = [UIFont systemFontOfSize:14];
        self.textField.returnKeyType = UIReturnKeySend;
        self.textField.textAlignment = NSTextAlignmentJustified;
        [self.backView addSubview:self.textField];
        
        self.placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,-15,290,60)];
        self.placeHolderLabel.font = WTFont(15);
        self.placeHolderLabel.numberOfLines = 0;
        self.placeHolderLabel.text = @"请输入你的意见最多300字";
        self.placeHolderLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTline2Gray];
        self.placeHolderLabel.backgroundColor =[UIColor clearColor];
        [self.textField addSubview:self.placeHolderLabel];


        
        
        self.yaoqingBut = [[UIButton alloc] init];
        
        [self.yaoqingBut setBackgroundImage:[UIImage imageNamed:@"发表-不可点击"] forState:UIControlStateNormal];
        [self.yaoqingBut setTitle:@"发表" forState:UIControlStateNormal];
        self.yaoqingBut.titleLabel.font = WTFont(17);
        [self.yaoqingBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_butbackColor] forState:UIControlStateNormal];
        [self.yaoqingBut addTarget:self action:@selector(sendString:) forControlEvents:UIControlEventTouchUpInside];
        self.yaoqingBut.enabled = NO;
        [self.backView addSubview:self.yaoqingBut];
        [self.yaoqingBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.textField.mas_bottom);
            make.left.equalTo(self.textField.mas_right).offset(W(15));
        }];
        [self addSubview:self.backView];
        
    }
   
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSLog(@"内容长度 = %zd , text= %@",textView.text.length, text);
    NSUInteger proposedNewLength = textView.text.length - range.length + text.length;
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        NSString *temp = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (temp.length != 0) {
            [self.textField resignFirstResponder];
            self.backView.frame =  CGRectMake(0, DEVICE_HEIGHT - 44, DEVICE_WIDTH, 44);
            if ([self.delegate respondsToSelector:@selector(sendKeyboard:)]) {
                [self.delegate sendKeyboard:self.textField.text];
                self.textField.text = @"";
            }
        }else{
            [CAToast showWithText:@"请输入内容"];
            return NO;
        }
        return YES; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    if (proposedNewLength >= 300)//可编辑300子        
    {
        [CAToast showWithText:@"超过300字，请修改后发表"];
        return NO;
        
    }
    return YES;
}

-(void)textViewDidChange:(UITextView*)textView
{
    if([textView.text length] == 0){
        self.placeHolderLabel.text = _contentText;
        self.yaoqingBut.enabled = NO;
        [self.yaoqingBut setBackgroundImage:[UIImage imageNamed:@"发表-不可点击"] forState:UIControlStateNormal];
        
    }else{
        self.yaoqingBut.enabled = YES;
        [self.yaoqingBut setBackgroundImage:[UIImage imageNamed:@"发表"] forState:UIControlStateNormal];
        self.placeHolderLabel.text = @"";//这里给空
    }
  
}

- (void) keyBoardWillHide:(NSNotification*) notification{
  
    NSLog(@"%@", NSStringFromCGRect(self.backView.frame));
    
    [UIView animateWithDuration:0.25 animations:^{
        if (self.isHideStatus) {
            self.backView.frame = CGRectMake(0, self.frame.size.height - self.backView.frame.size.height - 20, self.backView.frame.size.width, self.backView.frame.size.height);
        }
        else
        {
            self.backView.frame = CGRectMake(0, self.frame.size.height - self.backView.frame.size.height, self.backView.frame.size.width, self.backView.frame.size.height);
        }
        
    }];
}

- (void) keyBoardWillShow:(NSNotification*) notification{
   
   
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardEndFrame = [aValue CGRectValue];
    CGRect keyboardFrame = [self convertRect:keyboardEndFrame toView:nil];
    
    CGFloat keyboardHeight = keyboardFrame.size.height;
    
    if (self.first) {
        self.first = NO;
        return;
    }
//    if (self.isHideStatus) {
//        keyboardHeight += 20;
//    }
    if(self.isFrom){
        self.fenxiang.hidden = YES;
    }
    
    NSLog(@"%@", NSStringFromCGRect(self.backView.frame));
    
    [UIView animateWithDuration:0.25 animations:^{
       self.backView.frame = CGRectMake(0, self.frame.size.height - keyboardHeight, DEVICE_WIDTH, 100*DEVICEHEIGHT_SCALE);
    }];
    
    
}

-(void)showKeyboardView:(NSString *)text isHideStatus:(BOOL)isHideStatus
{
    self.isHideStatus = isHideStatus;
    _contentText = text;
    if (self.textField.text.length == 0) {
        self.placeHolderLabel.text = _contentText;
    }
    [self.textField becomeFirstResponder];
}

-(void)closeKeyboradView
{
    [self.textField resignFirstResponder];
    self.backView.frame =  CGRectMake(0, DEVICE_HEIGHT - 44, DEVICE_WIDTH, 44);
    NSString *temp = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (temp.length != 0) {
        self.textField.text = @"";
    }
    if ([self.delegate respondsToSelector:@selector(closeKeyborad:)]) {
        [self.delegate closeKeyborad:self.textField.text];
    }
}


-(void)sendString:(UIButton *)senser
{
    NSString *temp = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (temp.length != 0) {
        [self.textField resignFirstResponder];
        self.backView.frame =  CGRectMake(0, DEVICE_HEIGHT - 44, DEVICE_WIDTH, 44);
        if ([self.delegate respondsToSelector:@selector(sendKeyboard:)]) {
            [self.delegate sendKeyboard:self.textField.text];
            self.textField.text = @"";
        }
    }else{
        [CAToast showWithText:@"请输入内容"];
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
