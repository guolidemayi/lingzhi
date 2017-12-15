//
//  GLD_BindingPhoneController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/15.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_BindingPhoneController.h"
#import "BRTextField.h"
#import "BRDatePickerView.h"
#import "NSDate+BRAdd.h"
#import "GLD_CustomBut.h"
#import "GLD_BackForPasswordController.h"

@interface GLD_BindingPhoneController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong)UITableView *table_apply;
/** 手机号 */
@property (nonatomic, strong) BRTextField *phoneTF;
@property (nonatomic, strong) NSArray *titleArr;//

//验证码定时器
@property (nonatomic, strong)NSTimer *verificationTimer;
@property (nonatomic, weak)UIButton *verificationBut;

/** 验证码 */
@property (nonatomic, strong) BRTextField *verificationTF;

@property (nonatomic, strong)UIButton *applyBut;//提交
@end

@implementation GLD_BindingPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLD_CustomBut *locationBut = [[GLD_CustomBut alloc]init];;
    locationBut.frame = CGRectMake(0, 0, 50, 44);
    [locationBut title:@"保存"];
    [locationBut addTarget:self action:@selector(SaveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:locationBut];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.view addSubview:self.table_apply];
}
- (void)SaveAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"systemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.textColor = RGB_HEX(0x464646, 1.0f);
    cell.textLabel.text = self.titleArr[indexPath.row];
    switch (indexPath.row) {
        case 0:{
            [self setupPhoneTF:cell];
        }break;
        case 1:{
            [self setupVerificationTF:cell];
        }break;
        
            
    }
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [UITableViewHeaderFooterView new];
    [header.contentView addSubview:self.applyBut];
    [self.applyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(header.contentView);
        
        make.width.equalTo(WIDTH(300));
        make.height.equalTo(WIDTH(44));
    }];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return W(70);
}

- (void)sendVerificationClick:(UIButton *)senser{
    //验证码
    senser.enabled = NO;
    [senser setTitle:@"59" forState:UIControlStateNormal];
    self.verificationTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                              target:self
                                                            selector:@selector(timerAction:)
                                                            userInfo:nil
                                                             repeats:YES];
    
    
}
- (void)timerAction:(NSTimer *)timer{
    
    
    NSInteger time = [self.verificationBut.titleLabel.text integerValue];
    [self.verificationBut setTitle:[NSString stringWithFormat:@"%zd",--time] forState:UIControlStateNormal];
    if(time == 0){
        self.verificationBut.selected = NO;
        [self.verificationBut setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.verificationTimer invalidate];
        self.verificationTimer = nil;
    }
}


- (void)dealloc{
    [self.verificationTimer invalidate];
    self.verificationTimer = nil;
}

- (BRTextField *)getTextField:(UITableViewCell *)cell {
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - W(260), 0, W(200), W(50))];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = RGB_HEX(0x666666, 1.0);
    textField.delegate = self;
    [cell.contentView addSubview:textField];
    return textField;
}
#pragma mark - 验证码
- (void)setupVerificationTF:(UITableViewCell *)cell{
    if (!_verificationTF) {
        _verificationTF = [self getTextField:cell];
        _verificationTF.placeholder = @"请输入验证码";
        _verificationTF.returnKeyType = UIReturnKeyDone;
        _verificationTF.tag = 3;
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - W(130), W(5), W(100), W(40))];
        but.titleLabel.font = WTFont(15);
        _verificationTF.frame = CGRectMake(SCREEN_WIDTH - W(260), 0, W(100), W(50));
        [cell.contentView addSubview:but];
        [but setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
        but.layer.cornerRadius = 3;
        but.layer.masksToBounds = YES;
        but.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE].CGColor;
        but.layer.borderWidth = 1;
        self.verificationBut = but;
        [but setTitle:@"获取验证码" forState:UIControlStateNormal];
        [but addTarget:self action:@selector(sendVerificationClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

#pragma mark - 申请人身份证号
- (void)setupPhoneTF:(UITableViewCell *)cell{
    if (!_phoneTF) {
        _phoneTF = [self getTextField:cell];
        _phoneTF.placeholder = @"请填写手机号";
//        _phoneTF.textAlignment = NSTextAlignmentLeft;
        _phoneTF.returnKeyType = UIReturnKeyDone;
        _phoneTF.tag = 4;
    }
}
- (UITableView *)table_apply{
    if (!_table_apply) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        self.table_apply = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, W(15), 0, W(15))];
        tableView.mj_insetB = W(50);
        //        [tableView registerClass:[GLD_MapDetailCell class] forCellReuseIdentifier:GLD_MapDetailCellIdentifier];
        //        tableView.rowHeight = 0;
        tableView.sectionFooterHeight = 0.001;
    }
    return _table_apply;
}
- (UIButton *)applyBut{
    if (!_applyBut) {
        _applyBut = [[UIButton alloc]init];
        [_applyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKyellow] forState:UIControlStateNormal];
        [_applyBut setTitle:@"下一步" forState:UIControlStateNormal];
        _applyBut.titleLabel.font = WTFont(15);
        _applyBut.layer.cornerRadius = 3;
        _applyBut.layer.masksToBounds = YES;
        _applyBut.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow].CGColor;
        _applyBut.layer.borderWidth = 1;
        [_applyBut addTarget:self action:@selector(applybutClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBut;
}

- (void)applybutClick{
    //下一步
    GLD_BackForPasswordController *backVc = [GLD_BackForPasswordController new];
    [self.navigationController pushViewController:backVc animated:YES];
}
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"手机号",@"验证码"];
    }
    return _titleArr;
}
@end
