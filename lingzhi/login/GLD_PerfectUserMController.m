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

@interface GLD_PerfectUserMController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong)UITableView *table_apply;
/** 手机号 */
@property (nonatomic, strong) BRTextField *nameTF;

/** 密码 */
@property (nonatomic, strong) BRTextField *PersonTF;

/** 确认密码 */
@property (nonatomic, strong) BRTextField *phoneTF;
/** 邀请码 */
@property (nonatomic, strong) BRTextField *invitationTF;

@property (nonatomic, strong) NSArray *titleArr;//
@property (nonatomic, strong)UIButton *applyBut;//提交
@property (nonatomic, strong)UIButton *agreeBut;//同意
@end

@implementation GLD_PerfectUserMController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.table_apply];

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
#pragma mark - 申请人姓名
- (void)setupNameTF:(UITableViewCell *)cell{
    if (!_nameTF) {
        _nameTF = [self getTextField:cell];
        _nameTF.placeholder = @"请输入";
        _nameTF.returnKeyType = UIReturnKeyDone;
        _nameTF.tag = 0;
    }
}


#pragma mark - 申请人身份证号
- (void)setupPhoneTF:(UITableViewCell *)cell{
    if (!_phoneTF) {
        _phoneTF = [self getTextField:cell];
        _phoneTF.placeholder = @"请填写身份证号";
        _phoneTF.returnKeyType = UIReturnKeyDone;
        _phoneTF.tag = 4;
    }
}

#pragma mark - 备注
- (void)setupPersonTF:(UITableViewCell *)cell{
    if (!_PersonTF) {
        _PersonTF = [self getTextField:cell];
        _PersonTF.placeholder = @"请输入";
        _PersonTF.returnKeyType = UIReturnKeyDone;
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
        [_applyBut setTitle:@"申请合作" forState:UIControlStateNormal];
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
        [_agreeBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKyellow] forState:UIControlStateNormal];
        [_agreeBut setTitle:@"申请合作" forState:UIControlStateNormal];
        _agreeBut.titleLabel.font = WTFont(15);
        _applyBut.layer.cornerRadius = 3;
        _applyBut.layer.masksToBounds = YES;
        _applyBut.layer.borderColor = [YXUniversal colorWithHexString:COLOR_YX_DRAKyellow].CGColor;
        _applyBut.layer.borderWidth = 1;
        [_applyBut addTarget:self action:@selector(applybutClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyBut;
}
@end
