//
//  GLD_PerfectUserMController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/15.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_PerfectUserMController.h"
#import "BRTextField.h"
#import "BRDatePickerView.h"
#import "NSDate+BRAdd.h"
#import "GLD_CustomBut.h"
#import "GLD_BindingPhoneController.h"
#import "GLD_UserProtocolController.h"

@interface GLD_PerfectUserMController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong)UITableView *table_apply;
/** 确认密码 */
@property (nonatomic, strong) BRTextField *nameTF;

/** 密码 */
@property (nonatomic, strong) BRTextField *PersonTF;

/** 手机号 */
@property (nonatomic, strong) BRTextField *phoneTF;
/** 邀请码 */
@property (nonatomic, strong) BRTextField *invitationTF;

@property (nonatomic, strong) NSArray *titleArr;//
@property (nonatomic, strong)UIButton *applyBut;//提交
@property (nonatomic, strong)UIButton *agreeBut;//同意
@property (nonatomic, strong)UIButton *agreeMentBut;//用户协议
@end

@implementation GLD_PerfectUserMController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.table_apply];
    
    GLD_CustomBut *locationBut = [[GLD_CustomBut alloc]init];;
    locationBut.frame = CGRectMake(0, 0, 50, 44);
    [locationBut image:@"导航栏返回箭头"];
    [locationBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:locationBut];
    self.navigationItem.leftBarButtonItem = item;
    self.title = @"注册";

}
- (void)backAction{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [self.view endEditing:YES];
}
- (void)applybutClick{
    NSLog(@"提交");
    
    if (!IsExist_String(self.phoneTF.text) || ![YXUniversal isValidateMobile:self.phoneTF.text]) {
        [CAToast showWithText:@"请输入正确手机号"];
        return;
    }
    if (!IsExist_String(self.PersonTF.text)) {
        [CAToast showWithText:@"密码"];
        return;
    }
    if (![self.PersonTF.text isEqualToString:self.nameTF.text]) {
        [CAToast showWithText:@"两次密码不一致"];
        return;
    }
    if (self.agreeBut.selected == NO) {
        [CAToast showWithText:@"请阅读用户协议"];
        return;
    }
    //提交数据
    [AppDelegate shareDelegate].userModel.phone = self.phoneTF.text;
    [AppDelegate shareDelegate].userModel.password = self.PersonTF.text;
//    [AppDelegate shareDelegate].userModel.inverCode = self.invitationTF.text;
    GLD_BindingPhoneController *bindingVc = [GLD_BindingPhoneController new];
    if (IsExist_String(self.invitationTF.text)) 
    [[NSUserDefaults standardUserDefaults] setObject:self.invitationTF.text forKey:@"inverCode"];
    [self.navigationController pushViewController:bindingVc animated:YES];
}
- (void)agreeMentButClick{
    NSLog(@"用户协议");
    
    GLD_UserProtocolController *protoclVc = [GLD_UserProtocolController new];
    [self.navigationController pushViewController:protoclVc animated:YES];
}
- (void)agreeButClick:(UIButton *)senser{
    
    if (senser.selected) {
        senser.selected = NO;
        [senser setImage:WTImage(@"没选中") forState:UIControlStateNormal];
    }else{
        senser.selected = YES;
        [senser setImage:WTImage(@"勾选") forState:UIControlStateNormal];
    }
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
            [self setupNameTF:cell];
        }break;
        case 2:{
            
            [self setupPersonTF:cell];
        }break;
        case 3:{
            
            [self setupInvitationTF:cell];
        }break;
            
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [UITableViewHeaderFooterView new];
    [header.contentView addSubview:self.applyBut];
    [header.contentView addSubview:self.agreeMentBut];
    [header.contentView addSubview:self.agreeBut];
    [self.applyBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(header.contentView);
        make.centerY.equalTo(header.contentView).offset(W(30));
        make.width.equalTo(WIDTH(300));
        make.height.equalTo(WIDTH(44));
    }];
    [self.agreeBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(header.contentView).offset(W(10));
    }];
    [self.agreeMentBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.agreeBut);
        make.left.equalTo(self.agreeBut.mas_right);
    }];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return W(70);
}

- (BRTextField *)getTextField:(UITableViewCell *)cell {
    BRTextField *textField = [[BRTextField alloc]initWithFrame:CGRectMake(W(100), 0, W(200), W(50))];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.textColor = RGB_HEX(0x666666, 1.0);
    textField.delegate = self;
    [cell.contentView addSubview:textField];
    return textField;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - 申请人姓名
- (void)setupNameTF:(UITableViewCell *)cell{
    if (!_nameTF) {
        _nameTF = [self getTextField:cell];
        _nameTF.placeholder = @"请输入";
        _nameTF.keyboardType = UIKeyboardTypeNumberPad;
        _nameTF.returnKeyType = UIReturnKeyDone;
        _nameTF.tag = 0;
    }
}


#pragma mark - 申请人身份证号
- (void)setupPhoneTF:(UITableViewCell *)cell{
    if (!_phoneTF) {
        _phoneTF = [self getTextField:cell];
        _phoneTF.placeholder = @"请填写手机号";
        _phoneTF.returnKeyType = UIReturnKeyDone;
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTF.tag = 4;
    }
}

#pragma mark - 备注
- (void)setupPersonTF:(UITableViewCell *)cell{
    if (!_PersonTF) {
        _PersonTF = [self getTextField:cell];
        _PersonTF.placeholder = @"请输入";
        _PersonTF.returnKeyType = UIReturnKeyDone;
        _PersonTF.keyboardType = UIKeyboardTypeNumberPad;
        _PersonTF.tag = 1;
    }
}

#pragma mark - 邀请码
- (void)setupInvitationTF:(UITableViewCell *)cell{
    if (!_invitationTF) {
        _invitationTF = [self getTextField:cell];
        _invitationTF.placeholder = @"请输入推荐人邀请码";
        _invitationTF.returnKeyType = UIReturnKeyDone;
        _invitationTF.tag = 1;
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
- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"手机号",@"密码",@"确认密码",@"邀请码"];
    }
    return _titleArr;
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
- (UIButton *)agreeBut{
    if (!_agreeBut) {
        _agreeBut = [[UIButton alloc]init];
        [_agreeBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTnewGray] forState:UIControlStateNormal];
        [_agreeBut setTitle:@"我已同意" forState:UIControlStateNormal];
        _agreeBut.titleLabel.font = WTFont(12);
        _agreeBut.selected = YES;
        [_agreeBut setImage:WTImage(@"勾选") forState:UIControlStateNormal];
        [_agreeBut addTarget:self action:@selector(agreeButClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBut;
}
- (UIButton *)agreeMentBut{
    if (!_agreeMentBut) {
        _agreeMentBut = [[UIButton alloc]init];
        [_agreeMentBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKBLUE] forState:UIControlStateNormal];
        [_agreeMentBut setTitle:@"<用户协议>" forState:UIControlStateNormal];
        _agreeMentBut.titleLabel.font = WTFont(12);
        
        [_agreeMentBut addTarget:self action:@selector(agreeMentButClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeMentBut;
}
@end
