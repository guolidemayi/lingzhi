//
//  GLD_PhoneVerificatController.m
//  lingzhi
//
//  Created by yiyangkeji on 2017/12/12.
//  Copyright © 2017年 com.lingzhi. All rights reserved.
//

#import "GLD_PhoneVerificatController.h"
#import "BRTextField.h"
#import "BRDatePickerView.h"
#import "NSDate+BRAdd.h"

@interface GLD_PhoneVerificatController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong)UITableView *table_apply;
/** 门店名称 */
@property (nonatomic, strong) BRTextField *nameTF;

/** 负责人 */
@property (nonatomic, strong) BRTextField *PersonTF;

/** 门店电话 */
@property (nonatomic, strong) BRTextField *phoneTF;

@property (nonatomic, strong) NSArray *titleArr;//

@property (nonatomic, strong)UIButton *titleLabel;//标题
@property (nonatomic, strong)UILabel *tipLabel;//副标题
@property (nonatomic, strong)UIButton *applyBut;//现金
@property (nonatomic, strong)GLD_NetworkAPIManager *NetManager;
@end

@implementation GLD_PhoneVerificatController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.table_apply];
    self.NetManager = [GLD_NetworkAPIManager new];
    
}

- (void)getPhoneVer{
    WS(weakSelf);
    if(!IsExist_String(self.nameTF.text)){
        [CAToast showWithText:@"请输入姓名"];
        return;
    }
    if(!IsExist_String(self.PersonTF.text) || ![YXUniversal isValidateMobile:self.phoneTF.text]){
        [CAToast showWithText:@"请输入正确的手机号"];
        return;
    }
    if(!IsExist_String(self.phoneTF.text) || ![YXUniversal checkUserIDCard:self.phoneTF.text]){
        [CAToast showWithText:@"请输入正确的身份证号"];
        return;
    }
    GLD_APIConfiguration *config = [[GLD_APIConfiguration alloc]init];
    config.requestType = gld_networkRequestTypePOST;
    config.urlPath = @"api/user/certification";
    config.requestParameters = @{@"userId" : GetString([AppDelegate shareDelegate].userModel.userId),
                                 @"identityId" : GetString(self.phoneTF.text),
                                 @"phone" : GetString(self.PersonTF.text),
                                 @"userName" : GetString(self.nameTF.text),
                                 };
    
    [self.NetManager dispatchDataTaskWith:config andCompletionHandler:^(NSError *error, id result) {
        if (!error) {
            [CAToast showWithText:@"认证成功"];
        }else{
            [CAToast showWithText:@"认证失败"];
        }
        
    }];
}
- (void)applybutClick{
    [self getPhoneVer];
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
        
       
    }
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [UITableViewHeaderFooterView new];
    [header.contentView addSubview:self.titleLabel];
    [header.contentView addSubview:self.tipLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(header.contentView);
        make.top.equalTo(header.contentView).offset(W(10));
        make.height.equalTo(WIDTH(25));
        make.width.equalTo(WIDTH(100));
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(header.contentView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(W(5));
    }];
    return header;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return W(70);
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
        _nameTF.placeholder = @"请输入姓名";
        _nameTF.returnKeyType = UIReturnKeyDone;
        _nameTF.tag = 0;
    }
}


#pragma mark - 申请人身份证号
- (void)setupPhoneTF:(UITableViewCell *)cell{
    if (!_phoneTF) {
        _phoneTF = [self getTextField:cell];
//        _phoneTF.placeholder = @"请填写";
        _phoneTF.text = [AppDelegate shareDelegate].userModel.phone;
        _phoneTF.returnKeyType = UIReturnKeyDone;
        _phoneTF.tag = 4;
    }
}

#pragma mark - 备注
- (void)setupPersonTF:(UITableViewCell *)cell{
    if (!_PersonTF) {
        _PersonTF = [self getTextField:cell];
        _PersonTF.placeholder = @"请输入身份证";
        _PersonTF.returnKeyType = UIReturnKeyDone;
        _PersonTF.tag = 1;
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
        _titleArr = @[@"当前绑定",@"真实姓名",@"身份证号"];
    }
    return _titleArr;
}
- (UIButton *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UIButton alloc]init];
        _titleLabel.titleLabel.font = WTFont(15);
        [_titleLabel setTitle:@"温馨提示" forState:UIControlStateNormal];
        [_titleLabel setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTred] forState:UIControlStateNormal];
        [_titleLabel setImage:WTImage(@"warning") forState:UIControlStateNormal];
        
        
    }
    return _titleLabel;
}
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = WTFont(12);
        _tipLabel.text = @"请保证姓名，身份证信息能够匹配成功";
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.textColor = [YXUniversal colorWithHexString:COLOR_YX_GRAY_TEXTred];
    }
    return _tipLabel;
}
- (UIButton *)applyBut{
    if (!_applyBut) {
        _applyBut = [[UIButton alloc]init];
        [_applyBut setTitleColor:[YXUniversal colorWithHexString:COLOR_YX_DRAKyellow] forState:UIControlStateNormal];
        [_applyBut setTitle:@"提交审核" forState:UIControlStateNormal];
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
